#!/usr/bin/env python3

import requests
import json

data = requests.get("https://iceportal.de/api1/rs/status")

if data.status_code != 200:
    print(f"HTTP Status {data.status_code}")

t_info = data.json()

return_info={
        'text':t_info["tzn"],
        'tooltip':f'BR{t_info["series"]}, I-Netz {t_info["internet"]}',
        #'class':'',
        'percentage':t_info["speed"]
}

print(json.dumps(return_info))
