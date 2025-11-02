#!/usr/bin/env python3

ISYNC_TEMPLATE='''
{% for name, cfg in accounts.items() %}

IMAPStore {{ name }}-remote
Host {{ cfg.imap.host }}
Port {{ cfg.imap.port }}
User {{ cfg.imap.user }}
PassCmd "secret-tool lookup app neomutt account {{ name }} proto imap"
TLSType {{ cfg.imap.tlstype }}
CertificateFile /etc/ssl/certs/ca-certificates.crt

MaildirStore {{ name }}-local
Subfolders Verbatim
Path {{maildir}}/{{ name }}/
INBOX {{maildir}}{{ name }}/{{ cfg.imap.inbox }}
Flatten .

Channel {{ name }}
Far :{{ name }}-remote:
Near :{{ name }}-local:
Patterns *
SyncState *
Create Both
Expunge Both
MaxMessages 0

{% endfor %}
'''

MUTT_ACCOUNT_TEMPLATE='''
# vi: ft=neomuttrc

folder-hook {{ name }}/ "source {{ name }}.hook"
'''
MUTT_ACCOUNT_HOOK_TEMPLATE='''
# vi: ft=neomuttrc

set postponed = +{{ name }}/Drafts
set record = +{{ name }}/Sent
set trash = +{{ name }}/Trash
set from = "mail@example.com"
set realname = "Example Name"
'''

from jinja2 import Template
import yaml
import os
import subprocess
import getpass

SYNCDIR  = os.environ["DOTFILE_SYNCDIR"]
FILEBASE = os.environ["DOTFILEBASE"]

ACCOUNT_DIR = os.path.join(SYNCDIR,'mailaccounts.d')
MAIL_DIR = os.path.join(os.environ['HOME'], '.local', 'share', 'email')

def check_dir(dir) -> None:
    if not os.path.isdir(dir):
        os.mkdir(dir)
def check_dirs(*dirs) -> None:
    for dir in dirs:
        check_dir(dir)

with open(os.path.join(SYNCDIR,'mailaccounts.yaml')) as f:
    CONFIG = yaml.safe_load(f)

# TODO maybe not hardcode .config
with open(os.path.join(os.environ['HOME'], '.config', 'isyncrc'), 'w') as f:
    f.write( Template(ISYNC_TEMPLATE).render(accounts=CONFIG, maildir=MAIL_DIR) )

check_dirs(ACCOUNT_DIR, MAIL_DIR)

for name, cfg in CONFIG.items():
    conffile = os.path.join(ACCOUNT_DIR, f'{name}.conf')
    hookfile = os.path.join(ACCOUNT_DIR, f'{name}.hook')

    check_dir(os.path.join(MAIL_DIR, name))

    if not os.path.exists(conffile):
        with open(conffile, 'w') as f:
            f.write(
                Template(MUTT_ACCOUNT_TEMPLATE).render(name=name, cfg=cfg)
            )

    if not os.path.exists(hookfile):
        with open(hookfile, 'w') as f:
            f.write(
                Template(MUTT_ACCOUNT_HOOK_TEMPLATE).render(name=name, cfg=cfg)
            )

    if subprocess.run(
            ['secret-tool', 'lookup', 'app', 'neomutt', 'account', name, 'proto', 'imap'],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode != 0:

        pw = getpass.getpass(f'Input password for IMAP ({cfg["imap"]["user"]})')
        subprocess.run(
            ['secret-tool', 'store', '--label', 'neomutt {name} imap', 'app', 'neomutt', 'account', name, 'proto', 'imap'],
            input=pw, text=True
        )
