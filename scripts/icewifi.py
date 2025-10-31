#!/usr/bin/env python3

import requests
import json

TRIPINFO = "https://iceportal.de/api1/rs/tripInfo/trip"
STATUS = "https://iceportal.de/api1/rs/status"

data = requests.get(STATUS)
trip = requests.get(TRIPINFO)

if data.status_code != 200:
    print(f"Data HTTP Status {data.status_code}")
if trip.status_code != 200:
    print(f"Trip HTTP Status {data.status_code}")

t_info = data.json()
t_trip = trip.json()

#future_stops = [ e for e in t_trip['trip']['stops'] if not e['info']['passed'] ]

return_info={
        'text':f"{t_trip['trip']['trainType']} {t_trip['trip']['vzn']}",
        'tooltip':f'BR{t_info["series"]}({t_info["tzn"]}), I-Netz {t_info["connectivity"]["currentState"]}',
        #'class':'',
        'percentage':t_info["speed"]
}

print(json.dumps(return_info))
