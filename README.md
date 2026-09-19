# Arabic translation of the OPNsense GUI

A complete Arabic (`ar_SA`) translation of the OPNsense web interface: 14,467 strings, which
covers the core GUI of OPNsense 26.7, the plugins that ship with it and the menus, forms, help
texts, validation messages and dashboard widgets.

The upstream translation template lags behind the released GUI, so the strings were taken
from the running 26.7 interface as well as from the template. That is why the count is higher
than the 13,010 strings in the current `OPNsense.pot`.

Terminology follows the Arabic interfaces of Microsoft, Arabic Wikipedia and ESET where they
agree; [GLOSSARY.md](GLOSSARY.md) (in Arabic) lists the decisions and their sources.

![Arabic GUI](docs/gui-settings-ar.png)

*The Arabic GUI together with the right-to-left layout from opnsense-rtl.*

## Files

| File | Purpose |
| --- | --- |
| `ar_SA.po` | The translation. This is the file to edit. |
| `OPNsense.mo` | Compiled catalog, built with `msgfmt -c -o OPNsense.mo ar_SA.po`. |
| `install.sh` | Installs the catalog and adds Arabic to the language list. |
| `GLOSSARY.md` | Terminology decisions. |

## Installation

Arabic is not in the list of GUI languages yet, so the installer also adds it to
`/usr/local/etc/inc/system.inc` (a copy of the original is kept as `system.inc.orig-ar`).
Run as root on the firewall:

```sh
fetch -o /tmp/ar.tar.gz https://github.com/AbdelmonemAwad/opnsense-arabic/archive/refs/heads/main.tar.gz
tar -xzf /tmp/ar.tar.gz -C /tmp
sh /tmp/opnsense-arabic-main/install.sh
```

Then choose **العربية (Arabic)** under **System > Settings > General > Language**.

Firmware updates replace `system.inc` and may replace the catalog, so run the installer again
after an update.

The GUI stays left to right after this; the page layout is a separate project:
[opnsense-rtl](https://github.com/AbdelmonemAwad/opnsense-rtl).

## Status and plans

The aim is to get Arabic into OPNsense itself, where translations are maintained on POEditor.
Until then this repository is where corrections go. If a term reads wrong or a sentence is
awkward, open an issue or a pull request against `ar_SA.po`.

## ترجمة عربية لواجهة OPNsense

ترجمة كاملة لواجهة OPNsense إلى العربية (14,467 نصًا) لإصدار 26.7. التثبيت بالأوامر أعلاه، ثم
اختيار «العربية» من **النظام ← الإعدادات ← عام ← اللغة**. الملاحظات والتصحيحات مرحّب بها عبر
Issues أو Pull Requests.

## License

The translation is offered under the BSD 2-Clause License, the same as OPNsense. See
[LICENSE](LICENSE).
