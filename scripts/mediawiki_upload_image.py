#!/usr/bin/env python3

import os
import sys
from pywikibot import family
from pywikibot import Site
from pywikibot.specialbots import UploadRobot

import urllib3
urllib3.disable_warnings()

class Family(family.Family):
    name = 'muc.jag.re'
    langs = {
            'en': 'wiki.muc.jag.re'
    }
    def isPublic(self, code):
        return False
    def scriptpath(self, code):
        return ''
    def protocol(self, code):
        return 'HTTPS'
    def verify_SSL_certificate(self, code):
        return False


SITE=Site(code='en', fam=Family(),user='jonas')

def ask_or_env(env, prompt):
    if env in os.environ:
        return os.environ[env]
    print(prompt)
    return input()


def main():
    pic_of = ask_or_env('PICTURE_OF', 'Picture Of:')
    date = ask_or_env('PICTURE_DATE', 'Date:')

    for f in sys.argv[1:]:
        description=f'''
{{{{Image
|File={f}
|Picture Of={pic_of}
|Date={date}
}}}}
'''
        print('FILE: ', f)
        UploadRobot(url=f, keep_filename=True, summary='Uploaded by bot',
                    target_site=SITE, description=description).run()

if __name__ == '__main__':
    main()

