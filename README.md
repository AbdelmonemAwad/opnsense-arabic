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
| `install.sh` | Installs the catalog, adds Arabic to the language list, and installs the two pieces below. |
| `opnsense-arabic.ucl` | A pkg trigger: puts Arabic back in the list the moment an update rewrites `system.inc`. |
| `59-opnsense-arabic` | A boot hook: the same, at every boot. |
| `uninstall.sh` | Removes all of it. |
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

Firmware updates replace `system.inc`, and with it the language list. The installer leaves two
things behind so that nothing has to be run again after an update:

- a **pkg trigger**, `/usr/local/share/pkg/triggers/opnsense-arabic.ucl`, which pkg runs the moment a
  package writes `system.inc`. An update that only installs packages does not reboot, so this is
  the part that keeps Arabic in the list straight after one;
- a **boot hook**, `/usr/local/etc/rc.syshook.d/start/59-opnsense-arabic`, which does the same at every
  boot, and puts the catalog back if anything removed it. It runs before the plugins that add their
  own Arabic strings to the catalog.

Both run `install.sh --reapply` from the copy kept in `/usr/local/share/opnsense-arabic`. It adds only
what is missing: a catalog already in place is left alone, because the plugins' strings are in it.

To remove everything: `sh /usr/local/share/opnsense-arabic/uninstall.sh`.

The GUI stays left to right after this; the page layout is a separate project:
[opnsense-rtl](https://github.com/AbdelmonemAwad/opnsense-rtl).

## Status and plans

The aim is to get Arabic into OPNsense itself, where translations are maintained on POEditor.
Until then this repository is where corrections go. If a term reads wrong or a sentence is
awkward, open an issue or a pull request against `ar_SA.po`.

## In the XGS image

[xgs-image-builder](https://github.com/AbdelmonemAwad/xgs-image-builder) builds an OPNsense image
for Sophos XGS appliances with this repository in it, installed at the image's first boot. It holds
no copy of this repository: every build takes `main` as it is that day, so a change merged here is
in the next image without anything being done there. What the image calls here - `install.sh` - is checked
from that side every day, so moving or renaming one of them is caught there; keep them where they are.

## Updates

An installed copy follows this repository's **releases** by itself: once a day, at 03:11,
`/usr/local/share/opnsense-arabic/self-update.py` (from `/usr/local/etc/cron.d/opnsense-arabic-update`) asks GitHub for the latest release and, when it is ahead of what
is installed, downloads it and runs the `install.sh` it carries - the same script a hand install
runs. A change merged on `main` reaches installed firewalls when it is released, not before; with
no release published, nothing changes.

- **Only forward.** What is installed is recorded in `/usr/local/share/opnsense-arabic/installed.json` by
  the installer - the commit, from a git checkout or from the `.source-commit` stamp that an
  xgs-image-builder image or an update leaves in the tree. A firewall running something newer than
  the release is not taken back; an install from before the stamp existed takes the latest release
  once.
- **What happened** is in the system log as `self-update`, in
  `/usr/local/share/opnsense-arabic/update.json`, and the installer's output in `update.log` beside it.
- `/usr/local/share/opnsense-arabic/self-update.py check` says what it would do and changes nothing.

Tested in a QEMU virtual machine against a stand-in for GitHub (no release had been published):
a release ahead is installed, one that is not is left, no release and an unreachable GitHub change
nothing, and the uninstaller removes the updater, its cron entry and the stamp.

## ترجمة عربية لواجهة OPNsense

ترجمة كاملة لواجهة OPNsense إلى العربية (14,467 نصًا) لإصدار 26.7. التثبيت بالأوامر أعلاه، ثم
اختيار «العربية» من **النظام ← الإعدادات ← عام ← اللغة**. الملاحظات والتصحيحات مرحّب بها عبر
Issues أو Pull Requests.

## License

The translation is offered under the BSD 2-Clause License, the same as OPNsense. See
[LICENSE](LICENSE).

The photographs and screenshots under `docs/` are &copy; 2026 Abdelmonem Awad, under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/): use them freely, naming the author and linking here. Each carries that notice in a strip added below it.
