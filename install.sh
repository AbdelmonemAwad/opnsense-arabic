#!/bin/sh
# Install (or re-install after an OPNsense update) the Arabic GUI translation.
# Usage: sh install.sh [/path/to/OPNsense.mo]   (default: the OPNsense.mo next to this script)
set -e
MO=${1:-$(cd "$(dirname "$0")" && pwd)/OPNsense.mo}
DEST=/usr/local/share/locale/ar_SA/LC_MESSAGES
INC=/usr/local/etc/inc/system.inc

[ -f "$MO" ] || { echo "missing $MO"; exit 1; }
mkdir -p "$DEST"
install -m 0644 "$MO" "$DEST/OPNsense.mo"

# add Arabic to the language list (idempotent; system.inc is replaced by core updates)
if ! grep -q "ar_SA" "$INC"; then
    cp "$INC" "$INC.orig-ar"
    sed -i '' "/\$locales\['en_US'\] = gettext('English');/a\\
    \$locales['ar_SA'] = 'العربية (Arabic)';
" "$INC"
fi
grep -n "ar_SA" "$INC"
php -l "$INC" >/dev/null && echo "system.inc OK"

# translations are cached by php-fpm / the web server
configctl webgui restart >/dev/null 2>&1 || true
echo "Arabic translation installed: $(stat -f %z "$DEST/OPNsense.mo") bytes"
