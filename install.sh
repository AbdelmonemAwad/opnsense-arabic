#!/bin/sh
# Copyright (C) 2026 Abdelmonem Awad <eg2@live.com>. BSD 2-Clause License, see LICENSE.
#
# Install the Arabic GUI translation, and keep it installed across OPNsense updates.
#
#   sh install.sh [/path/to/OPNsense.mo]     install, or update to this catalog
#   sh install.sh --reapply [--no-restart]   put back what an update took away; the boot hook
#                                            and the package trigger call this, nobody else needs to
#
# WHAT AN UPDATE TAKES AWAY. The language list is in system.inc, which belongs to the opnsense
# package and is replaced by every update that changes it. The catalog belongs to no package, so
# updates leave it where it is. So the list entry is the part that goes missing, and it has to come
# back by itself.
#
# WHEN IT COMES BACK. An update that only installs packages does not reboot, so a boot hook on its
# own would leave Arabic out of the list until the next reboot, however long that is. pkg runs the
# trigger (opnsense-arabic.ucl) the moment it writes system.inc, and the boot hook
# (59-opnsense-arabic) covers whatever else replaced the file. 59 because the plugins that add
# their own Arabic strings to this catalog run at 60 and above, and the catalog has to be there
# before they can add to it.
#
# Both call this with --reapply, which installs the catalog only if it is missing: the plugins'
# strings live in the installed copy, and putting the pristine one over it would remove them.

HERE=$(cd "$(dirname "$0")" && pwd)
KEEP=/usr/local/share/opnsense-arabic
DEST=/usr/local/share/locale/ar_SA/LC_MESSAGES
INC=/usr/local/etc/inc/system.inc
HOOK=/usr/local/etc/rc.syshook.d/start/59-opnsense-arabic
TRIGGER=/usr/local/share/pkg/triggers/opnsense-arabic.ucl
CRON=/usr/local/etc/cron.d/opnsense-arabic-update
ANCHOR="\$locales['en_US'] = gettext('English');"

REAPPLY=
RESTART=1
MO=
for arg in "$@"; do
    case ${arg} in
    --reapply)    REAPPLY=1 ;;
    --no-restart) RESTART= ;;
    *)            MO=${arg} ;;
    esac
done

log() { /usr/bin/logger -t opnsense-arabic -p daemon.notice "$1" 2>/dev/null || true; }

# Arabic in the language list. Returns 0 only if it was added now.
add_to_list() {
    grep -q "'ar_SA'" "${INC}" && return 1
    if ! grep -qF "${ANCHOR}" "${INC}"; then
        # A release that writes the English entry differently. Saying so is the whole fix: a
        # guess at a new anchor would edit a file the web GUI cannot run without.
        echo "the English entry is not where it was in ${INC}; Arabic was not added to the list" >&2
        log "Arabic not added to the language list: the anchor line is not in ${INC}"
        return 1
    fi
    cp "${INC}" "${INC}.orig-ar"
    sed -i '' "/\$locales\['en_US'\] = gettext('English');/a\\
    \$locales['ar_SA'] = 'العربية (Arabic)';
" "${INC}"
    if ! php -l "${INC}" > /dev/null 2>&1; then
        cp "${INC}.orig-ar" "${INC}"
        echo "${INC} did not compile with Arabic added; the original is back" >&2
        log "Arabic not added to the language list: the edited system.inc did not compile"
        return 1
    fi
    return 0
}

# Every installed plugin that adds its own strings to the catalogs. Run after the catalog has
# been written, because writing it removed theirs.
merge_plugins() {
    for m in /usr/local/opnsense/scripts/*/merge_ui_translations.py; do
        [ -f "${m}" ] && /usr/local/bin/python3 "${m}" > /dev/null 2>&1 || true
    done
}

restart_gui() {
    # running php processes keep system.inc and the catalog they loaded
    [ -n "${RESTART}" ] && configctl webgui restart > /dev/null 2>&1 || true
}

if [ -n "${REAPPLY}" ]; then
    changed=
    if [ ! -f "${DEST}/OPNsense.mo" ] && [ -f "${KEEP}/OPNsense.mo" ]; then
        mkdir -p "${DEST}"
        install -m 0644 "${KEEP}/OPNsense.mo" "${DEST}/OPNsense.mo"
        merge_plugins
        changed="the catalog"
    fi
    if add_to_list; then
        changed="${changed:+${changed} and }the language list entry"
    fi
    if [ -n "${changed}" ]; then
        log "put back ${changed} after an update"
        restart_gui
    fi
    exit 0
fi

set -e
MO=${MO:-${HERE}/OPNsense.mo}
[ -f "${MO}" ] || { echo "missing ${MO}"; exit 1; }

mkdir -p "${DEST}" "${KEEP}"
install -m 0644 "${MO}" "${DEST}/OPNsense.mo"
# The pristine copy the reapply restores from, if an update or anything else removes the catalog.
[ "${MO}" -ef "${KEEP}/OPNsense.mo" ] || install -m 0644 "${MO}" "${KEEP}/OPNsense.mo"
if [ "${HERE}" != "${KEEP}" ]; then
    install -m 0755 "${HERE}/install.sh" "${KEEP}/install.sh"
    install -m 0755 "${HERE}/uninstall.sh" "${KEEP}/uninstall.sh"
    install -m 0755 "${HERE}/59-opnsense-arabic" "${HOOK}"
    mkdir -p "$(dirname "${TRIGGER}")"
    install -m 0644 "${HERE}/opnsense-arabic.ucl" "${TRIGGER}"
    install -m 0755 "${HERE}/self-update.py" "${KEEP}/self-update.py"
    # No daily self-update since 2026-10-20: a release is installed from XGS: Updates
    # (its Plugins tab, in os-xgs-npu) or by hand with self-update.py. An older
    # install's cron entry goes.
    rm -f "${CRON}"
    # What this install is, for the self-update: the commit, from a git checkout, or from the
    # .source-commit stamp that an xgs-image-builder image or the self-update leaves in the tree.
    # Without either it is recorded as unknown, and the self-update takes the latest release once.
    REV=; RDATE=; RSRC=unknown
    if [ -e "${HERE}/.git" ] && REV=$(git -C "${HERE}" rev-parse HEAD 2>/dev/null); then
        RDATE=$(git -C "${HERE}" log -1 --format=%cI 2>/dev/null); RSRC=git
    elif [ -s "${HERE}/.source-commit" ]; then
        read -r REV RDATE _ < "${HERE}/.source-commit"; RSRC=stamp
    else
        REV=
    fi
    case ${REV} in *[!0-9a-f]*) REV=; RDATE=; RSRC=unknown ;; esac
    install -d -m 0755 "${KEEP}"
    printf '{"commit": "%s", "date": "%s", "source": "%s", "installed_at": %s}\n' \
        "${REV}" "${RDATE}" "${RSRC}" "$(date +%s)" > "${KEEP}"/installed.json
fi

add_to_list || true
grep -q "'ar_SA'" "${INC}" && echo "Arabic is in the language list"
merge_plugins
restart_gui
echo "Arabic translation installed: $(stat -f %z "${DEST}/OPNsense.mo") bytes"
echo "kept across updates by ${TRIGGER} and ${HOOK}"
echo "a new release: XGS: Updates, Plugins - or ${KEEP}/self-update.py by hand"
