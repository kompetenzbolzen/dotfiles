#!/usr/bin/env python3
'''
# EXAMPLE CONFIG:
---
mymail:
  imap:
    host: imap.example.com
    port: 993
    user: user@example.com
    tlstype: IMAPS
    inbox: INBOX
  smtp:
    host: smtp.example.com
    port: 465
    user: user@example.com
    from: user@example.com

'''

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
Path {{maildir}}/{{ name }}/
Inbox {{maildir}}/{{ name }}/INBOX
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


MSMTP_TEMPLATE='''
defaults
tls on
tls_starttls off
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile -
set_from_header on
auth on

account undef
host localhost
account default: undef

{%- for name, cfg in accounts.items() %}

account {{ name }}
host {{ cfg.smtp.host }}
port {{ cfg.smtp.port }}
user {{ cfg.smtp.user }}
passwordeval secret-tool lookup app neomutt account {{ name }} proto smtp
from {{ cfg.smtp.from }}

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

def check_creds(label, *args):
    if subprocess.run(
            ['secret-tool', 'lookup', *args],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode != 0:

        pw = getpass.getpass(f'Input password for {label}: ')
        subprocess.run(
            ['secret-tool', 'store', '--label', label, *args],
            input=pw, text=True
        )

with open(os.path.join(SYNCDIR,'mailaccounts.yaml')) as f:
    CONFIG = yaml.safe_load(f)

# TODO maybe not hardcode .config

check_dir(os.path.join(os.environ['HOME'], '.config', 'msmtp'))
with open(os.path.join(os.environ['HOME'], '.config', 'msmtp', 'config'), 'w') as f:
    f.write( Template(MSMTP_TEMPLATE).render(accounts=CONFIG) )

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

    check_creds(f'neomutt {name} smtp', 'app', 'neomutt', 'account', name, 'proto', 'smtp')
    if subprocess.run(
            ['secret-tool', 'lookup', 'app', 'neomutt', 'account', name, 'proto', 'imap'],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode != 0:

        pw = getpass.getpass(f'Input password for IMAP ({cfg["imap"]["user"]})')
        subprocess.run(
            ['secret-tool', 'store', '--label', 'neomutt {name} imap', 'app', 'neomutt', 'account', name, 'proto', 'imap'],
            input=pw, text=True
        )
