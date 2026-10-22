# Arabic translation of the OPNsense GUI

A complete Arabic (`ar_SA`) translation of the OPNsense web interface: ~~14,467 strings~~ 15,721
strings, which covers the core GUI of OPNsense 26.7, the plugins that ship with it and the menus,
forms, help texts, validation messages and dashboard widgets - and, since 2026-10-22, the pages of
the Sophos XGS plugins too (below).

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
  boot, and puts the catalog back if anything removed it. ~~It runs before the plugins that add their
  own Arabic strings to the catalog.~~ Since 2026-10-22 those strings are in the catalog itself.

Both run `install.sh --reapply` from the copy kept in `/usr/local/share/opnsense-arabic`. It adds only
what is missing: a catalog already in place is left alone.

## The Sophos XGS plugins

Since 2026-10-22 the Arabic of the plugins' pages is here, in `ar_SA.po`, with the rest of the GUI
([issue 5](https://github.com/AbdelmonemAwad/opnsense-arabic/issues/5)): 1,254 strings added from
their own tables, each marked with the plugin it came from (`#: os-xgs-npu`, and so on). Until then
each plugin kept its own table and merged it into the installed catalog at install, at every boot
and from a pkg trigger; those tables and merges are gone from the plugins' new releases.

| plugin | its strings | added here | already translated here |
|---|---|---|---|
| [os-xgs-npu](https://github.com/AbdelmonemAwad/os-xgs-npu) | 566 | 490 | 76 |
| [os-fanctl](https://github.com/AbdelmonemAwad/os-fanctl) | 242 | 221 | 21 |
| [os-linkhealth](https://github.com/AbdelmonemAwad/os-linkhealth) | 389 | 350 | 39 |
| [os-frontpanel](https://github.com/AbdelmonemAwad/os-frontpanel) | 221 | 184 | 37 |
| [os-netreport](https://github.com/AbdelmonemAwad/os-netreport) | 106 | 9 | 97 |

- **A string this catalog already translated kept its Arabic here**, as each plugin's merge always
  left it; 28 plugin strings had other words for it.
- **A string two plugins translated differently** gets one Arabic here; the appliances had shown
  whichever plugin merged first. Each was read where it is used and given the most exact word:
  *Chip* - الشريحة; "The settings were saved, but the service did not take them." - ... لم تأخذ بها;
  *turned off*, a service's state beside *stopped* (متوقف), - مُطفأ; *up*, *down* and *no link* - متصل،
  منقطع، غير متصل, as this catalogue's *Connected* and *Disconnected*; *not recorded* - غير مسجّل.
  *read* and *not read* meant "was read" in os-xgs-npu and os-fanctl and "are being read" on
  os-frontpanel's keys card, so os-frontpanel has its own two strings now, *being read* - تُقرأ and
  *not being read* - لا تُقرأ (2026-10-22).
- **A string added to a plugin's page needs its Arabic here first.** Each plugin's checks read this
  catalog from `main` and fail a page string without Arabic in it.
- os-netreport's reports are written in its own language files, and its GUI in the languages other
  than Arabic is still merged by it; only the GUI's Arabic moved here.
- os-linkhealth's terminology notes moved here too: `i18n/glossary-os-linkhealth.json`.

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

An installed copy is updated to this repository's **releases** by hand: from **XGS: Updates**, its *Plugins*
tab ([os-xgs-npu](https://github.com/AbdelmonemAwad/os-xgs-npu)), or with `/usr/local/share/opnsense-arabic/self-update.py`. ~~Once a day, at 03:11, from `/usr/local/etc/cron.d/opnsense-arabic-update`~~ - nothing
is installed on its own since 2026-10-20, at the owner's word. It asks GitHub for the latest release and, when it is ahead of what
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
