#!/usr/bin/env python3

import requests
import json

# NOTE the api is pretty cool. maybe implement bar queue?
# https://www.vulpinecitrus.info/blog/the-sncf-wifi-api/

SPEED='https://wifi.sncf/router/api/train/gps'
speed = requests.get(SPEED)

if speed.status_code != 200:
    print(f"Data HTTP Status {speed.status_code}")

t_speed = int(speed.json()['speed']) * 3.6

return_info={
        'text':f"",
        'tooltip':f'',
        #'class':'',
        'percentage':t_speed
}

print(json.dumps(return_info))
