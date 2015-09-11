#!/usr/bin/python
#input parameters are year,month,day, output parameter is dyasofyear
import sys
import datetime
from optparse import OptionParser

parser = OptionParser()

(options,args)=parser.parse_args()

if len(args) != 3:
	print("need three parameters:year,month,day")
	sys.exit(1)

year=int(args[0])
month=int(args[1])
day=int(args[2])

date=datetime.datetime(year,month,day)

daysofyear=date.strftime('%j')

f = open('./daysofyear', 'w')

f.write(daysofyear)


	
