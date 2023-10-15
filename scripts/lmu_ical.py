#!/usr/bin/env python3
import icalendar
import sys

# Fix LMU LSF iCal files
# first arg is original file

e = open(sys.argv[1], 'rb')
cal = icalendar.Calendar.from_ical(e.read())
e.close()

for component in cal.walk():
   if component.name == "VEVENT":
       if 'exdate' in component and component['exdate'] is None:
           del component['exdate']

f = open('fixed.ics', 'wb')
f.write(cal.to_ical())
f.close()
