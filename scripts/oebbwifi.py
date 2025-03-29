#!/usr/bin/env python3

import requests
import json

SPEED = "https://railnet.oebb.at/api/speed"

speed = requests.get(SPEED)

if speed.status_code != 200:
    print(f"Data HTTP Status {speed.status_code}")

# NOTE OEBB does not convert from m/s to km/h
t_speed = int(speed.text) * 3.6

return_info={
        'text':f"",
        'tooltip':f'',
        #'class':'',
        'percentage':t_speed
}

print(json.dumps(return_info))
