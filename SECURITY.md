# Security

## Reporting a vulnerability

**Not in a public issue, please.** Report it privately through GitHub -
[**Report a vulnerability**](https://github.com/AbdelmonemAwad/opnsense-arabic/security/advisories/new),
on the Security tab - where only you and the owner see it, and the fix can be prepared before anything is
public. Without a GitHub account, write to **eg2@live.com**. Either way, include:

- what is affected - the translation file, the installer, the boot hook and the self-update;
- the version you installed and the OPNsense version;
- how to reproduce it, and what you saw.

This is one person's project, worked on in the evenings: expect an answer within days, not hours.
A fix is made in a pull request and the reporter credited in it, unless they ask not to be.

## What is supported

The newest version on `main`, and the newest release where there are releases. Fixes go there,
with no backports.

## Worth knowing before you report

- **A translation is text a page prints.** A string that carries markup or script into a page of the GUI is a vulnerability: report it here, privately, with the string's English original.
- The installer and the self-update run as root: anything that makes them install something other than this repository's files is a vulnerability.
- **Never send a configuration backup.** It holds keys and passwords.
