#!/bin/bash
#this script automatically setup qsub 

month=10

while [ "$month" -le 12 ]

do

qstat -a |grep jzhu >qlist

vv=(`wc -l qlist`)

num=${vv[0]}

if [ "$num" -lt 10 ];then

case $month in

10)

echo "10"
./process_oneyear_dailysnow_v2.bash 2014 20141001 20141031
;;
11)
echo "11"
./process_oneyear_dailysnow_v2.bash 2014 20141101 20141130
;;
12)
echo "12"
./process_oneyear_dailysnow_v2.bash 2014 20141201 20141231
;;
esac

let "month = $month + 1"

fi

sleep 30m

done
