#!/bin/bash
#this read a file which includes days. This script process those days defined in the file.
#day list file is located in $org_dir/$year
#input: day_list, day in day_list is in format yyyymmdd


org_dir=/center/w/jzhu/nps/snow_metrics

prg_dir=$HOME/nps/cesu/snow_metrics/scripts

wrk_data=/center/w/jzhu/nps/snow_metrics

log_dir=$wrk_data/logs
err_dir=$wrk_data/errors

mkdir -p $log_dir
mkdir -p $err_dir


if [ $# != 1 ]; then
echo 
echo "this script takes one parameter: day_list"
echo
exit 1
fi

day_list=$1



while read day
do
yyyy=`echo $day | cut -c1-4`
mm=`echo $day | cut -c5-6`
dd=`echo $day | cut -c7-8`

cur_date=`date +%Y%m%d-%H%M%S`

#set up stout and stderr to a file

LOG=$log_dir/oneyear_mosaic_resample_$day_${cur_date}.log
ERR=$err_dir/oneyear_mosaic_resample_$day_${cur_date}.err
exec 1>$LOG 2>$ERR

#$prg_dir/Grid_one_dailysnow_v2.bash $org_dir $yyyy $mm $dd

qsub -v ddir=$org_dir,year=$yyyy,mm=$mm,dd=$dd $HOME/nps/cesu/snow_metrics/scripts/Grid_one_dailysnow_v2.pbs


done < ${day_list}

exit 0
