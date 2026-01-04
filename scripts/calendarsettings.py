#!/usr/bin/env python3
'''yaml
# EXAMPLE CONFIG:
---
private:
  type: caldav
  user: name
  url: https://example.invalid/calendar.ics
contacts:
  type: carddav
  user: name
  url: https://example.invalid/contacts
'''

VDIRSYNCER_TEMPLATE='''# vi: ft=toml
# This file is managed by calendarsettings.py.
# Do not change!

[general]
status_path = "~/.config/vdirsyncer/status/"

{% for name, cfg in accounts.items() %}

[pair {{ name }}]
a = "{{ name }}_remote"
b = "{{ name }}_local"
collections = ["from a", "from b"]
{% if cfg.type == "caldav" %}
metadata = ["color"]
{% endif %}

[storage {{ name }}_local]
type = "filesystem"
path = "{{vdir}}/{{cfg.type}}/"
{% if cfg.type == "carddav" %}
fileext = ".vcf"
{% elif cfg.type == "caldav" %}
fileext = ".ics"
{% endif %}

[storage {{ name }}_remote]
type = "{{cfg.type}}"
url = "{{cfg.url}}"
username = "{{cfg.user}}"
password.fetch = ["command", "secret-tool", "lookup", "app", "vdirsyncer", "account", "{{ name }}"]

{% endfor %}
'''

from jinja2 import Template
import yaml
import os
import subprocess
import getpass

SYNCDIR  = os.environ["DOTFILE_SYNCDIR"]
FILEBASE = os.environ["DOTFILEBASE"]

#ACCOUNT_DIR = os.path.join(SYNCDIR,'mailaccounts.d')
V_DIR = os.path.join(os.environ['HOME'], '.local', 'share', 'vdirsyncer')

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

with open(os.path.join(SYNCDIR,'vdiraccounts.yaml')) as f:
    CONFIG = yaml.safe_load(f)

check_dirs(
        os.path.join(os.environ['HOME'], '.config', 'vdirsyncer'),
        V_DIR
        )
with open(os.path.join(os.environ['HOME'], '.config', 'vdirsyncer', 'config'), 'w') as f:
    f.write( Template(VDIRSYNCER_TEMPLATE).render(accounts=CONFIG, vdir=str(V_DIR)) )


for name, cfg in CONFIG.items():
    check_creds(f'vdirsyncer {name}', 'app', 'vdirsyncer', 'account', name)

print('''
Done.
run "vdirsyncer discover" after config change.
''')
