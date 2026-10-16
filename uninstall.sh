#!/bin/sh
# Copyright (C) 2026 Abdelmonem Awad <eg2@live.com>. BSD 2-Clause License, see LICENSE.
#
# Remove the Arabic translation. The package trigger and the boot hook go first, so nothing puts
# it back, then the language list entry and the catalog. A GUI left set to Arabic falls back to
# the untranslated English strings.
INC=/usr/local/etc/inc/system.inc

rm -f /usr/local/share/pkg/triggers/opnsense-arabic.ucl
rm -f /usr/local/etc/rc.syshook.d/start/59-opnsense-arabic

if grep -q "'ar_SA'" "${INC}"; then
    cp "${INC}" "${INC}.orig-ar-removed"
    sed -i '' "/\$locales\['ar_SA'\]/d" "${INC}"
    if ! php -l "${INC}" > /dev/null 2>&1; then
        cp "${INC}.orig-ar-removed" "${INC}"
        echo "${INC} did not compile without the Arabic entry; left as it was" >&2
    fi
fi

rm -f /usr/local/share/locale/ar_SA/LC_MESSAGES/OPNsense.mo
rmdir /usr/local/share/locale/ar_SA/LC_MESSAGES /usr/local/share/locale/ar_SA 2>/dev/null || true
rm -rf /usr/local/share/opnsense-arabic

configctl webgui restart > /dev/null 2>&1 || true
echo "Arabic translation removed"
