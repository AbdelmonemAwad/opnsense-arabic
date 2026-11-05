#!/usr/bin/env python3
#-
# SPDX-License-Identifier: BSD-2-Clause
# Copyright (c) 2026 Abdelmonem Awad <eg2@live.com>
#
"""The strings the plugins' pages show with no Arabic here yet, kept as one issue.

    python3 tools/waiting.py             open, update or close the issue "Strings waiting for Arabic"
    python3 tools/waiting.py --dry-run   print the issue as it would be, and touch nothing

A contributor who does not write Arabic may leave it out of a plugin's pull request (each plugin's
CONTRIBUTING.md): the change is merged, its strings show in English, and this is where they wait.
Each repository's own check finds them - run here against this checkout's ar_SA.po with
ARABIC_LATER=1, which writes every string without Arabic as a line
"::warning title=Arabic to follow::<string>". The issue lists them repository by repository and is
closed when none waits. A check that fails for another reason, or a repository that cannot be
fetched, fails this run after the issue is written. Run by .github/workflows/waiting.yml.
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile

OWNER = 'AbdelmonemAwad'
CHECKS = {
    'os-xgs-npu': ['tools/check-gui-strings.py', '.'],
    'os-blocklists': ['tools/check-strings.py'],
    'os-fallbackcrypto': ['tools/check-strings.py'],
    'os-fanctl': ['tools/check-strings.py'],
    'os-frontpanel': ['tools/check-strings.py'],
    'os-kernelfollow': ['tools/check-strings.py'],
    'os-linkhealth': ['tools/check-strings.py'],
    'os-netreport': ['install/check_i18n.py'],
    'os-portguard': ['tools/check-strings.py'],
    'os-watchdog': ['tools/check-strings.py'],
}
TITLE = 'Strings waiting for Arabic'
MARK = '::warning title=Arabic to follow::'
PO = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'ar_SA.po')
CATALOGUE = 'https://github.com/%s/opnsense-arabic/blob/main/ar_SA.po' % OWNER
AUTOMATED = '<sub>This is an automated message.</sub>'


def unescape(s):
    return s.replace('%0A', '\n').replace('%0D', '\r').replace('%25', '%')


def waiting(local):
    """{repository: (its strings without Arabic, its check's exit code, or None when not fetched)}.
    local maps a repository to a checkout used in place of a clone of its main - a test here."""
    found = {}
    env = {k: v for k, v in os.environ.items()
           if k not in ('GH_TOKEN', 'GITHUB_TOKEN', 'GITHUB_STEP_SUMMARY', 'ARABIC_LATER', 'ARABIC_PO')}
    env.update(ARABIC_PO=PO, ARABIC_LATER='1')
    with tempfile.TemporaryDirectory() as tmp:
        for repo, check in CHECKS.items():
            dest = local.get(repo) or os.path.join(tmp, repo)
            if repo not in local:
                cloned = subprocess.run(['git', 'clone', '--quiet', '--depth', '1',
                                         'https://github.com/%s/%s.git' % (OWNER, repo), dest],
                                        capture_output=True, text=True)
                if cloned.returncode != 0:
                    print('%s: not fetched - %s' % (repo, cloned.stderr.strip()[-200:]))
                    found[repo] = ([], None)
                    continue
            done = subprocess.run([sys.executable] + check, cwd=dest, env=env, capture_output=True, text=True)
            strings = sorted({unescape(line.split(MARK, 1)[1]) for line in done.stdout.splitlines() if MARK in line})
            print('%s: %d waiting, its check exit %d' % (repo, len(strings), done.returncode))
            if done.returncode != 0:
                print('   ' + '\n   '.join(done.stdout.strip().splitlines()[-5:]))
            found[repo] = (strings, done.returncode)
    return found


def body(found):
    lines = ["The strings the plugins' pages show with no Arabic in [ar_SA.po](%s) yet, repository by "
             'repository. Each shows in English until its Arabic is added there: a contributor who does not '
             "write Arabic may leave it out of a plugin's pull request. Kept by `tools/waiting.py` - weekly, on "
             'every push to main and by hand - and closed when none waits.' % CATALOGUE, '']
    for repo, (strings, _) in found.items():
        if strings:
            lines += ['### [%s](https://github.com/%s/%s)' % (repo, OWNER, repo), '']
            lines += ['- [ ] %s' % ' '.join(s.split()) for s in strings]
            lines.append('')
    lines.append(AUTOMATED)
    return '\n'.join(lines) + '\n'


def gh(*args, text=None):
    repo = os.environ.get('GITHUB_REPOSITORY', OWNER + '/opnsense-arabic')
    done = subprocess.run(['gh'] + list(args) + ['-R', repo], input=text, capture_output=True, text=True)
    if done.returncode != 0:
        sys.exit('gh %s: %s' % (args[0], done.stderr.strip()))
    return done.stdout


def the_issue():
    """(number, state) of the issue with this title - the open one first - or (None, None)."""
    out = gh('issue', 'list', '--state', 'all', '--search', '"%s" in:title' % TITLE,
             '--json', 'number,title,state', '--limit', '50')
    mine = sorted((i for i in json.loads(out) if i['title'] == TITLE), key=lambda i: i['state'] != 'OPEN')
    return (mine[0]['number'], mine[0]['state']) if mine else (None, None)


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--local', action='append', default=[], metavar='REPO=PATH',
                    help='use this checkout of REPO instead of a clone of its main (a test)')
    args = ap.parse_args(argv)
    found = waiting(dict(item.split('=', 1) for item in args.local))
    count = sum(len(s) for s, _ in found.values())
    broken = [repo for repo, (_, code) in found.items() if code != 0]
    if args.dry_run:
        print(body(found) if count else 'none waits')
    else:
        number, state = the_issue()
        if count:
            if number is None:
                gh('issue', 'create', '--title', TITLE, '--body-file', '-', text=body(found))
            else:
                if state != 'OPEN':
                    gh('issue', 'reopen', str(number))
                gh('issue', 'edit', str(number), '--body-file', '-', text=body(found))
        elif number is not None and state == 'OPEN':
            gh('issue', 'close', str(number), '--reason', 'completed',
               '--comment', 'None waits now: every string the pages show has its Arabic.\n\n' + AUTOMATED)
    print('%d string(s) waiting for Arabic; %s' % (count, 'checks failing otherwise: ' + ', '.join(broken)
                                                    if broken else 'every check ran'))
    return 1 if broken else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
