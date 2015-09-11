#!/bin/bash
#this script copy one-day data from /projects/UAFGINA to $wrk_dir, then do process to produce tif files,
#then copy the tif files into des_dir/$year/tif
#inputs:year,mm,dd

$HOME/nps/cesu/snow_metrics/scripts/setup

#example $year $mm $dd are: 2011 01 01
#take three parameters: year mm dd from qsub -v year=$year,mm=$mm,dd=$dd

date

year=$1
mm=$2
dd=$3

wrk_dir=$CENTER/nps/snow_metrics/$year

des_dir=/projects/UAFGINA/nps_snow/terra/daily/$year/tif

# 1. copy raw tile files to $wrk_dir

./copy_one_dailysnow_wrkdir_v2.bash $year $mm $dd

if [ ! $? == 0 ]; then

echo "copy failed,exit"

exit 1

fi

# 2. produce one day daily tif files

echo "start to process one daily data"

#echo $year $Ayyyyddd>/u1/uaf/jzhu/nps/cesu/snow_metrics/scripts/tst

#$HOME/nps/cesu/snow_metrics/scripts/Grid_one_dailysnow_v2.bash $CENTER/nps/snow_metrics $year $mm $dd

qsub -v year=$year,mm=$mm,dd=$dd $HOME/nps/cesu/snow_metrics/scripts/Grid_one_dailysnow_v2.pbs

echo "finish processing the $wrk_dir/$year/$yyyy.$mm.$dd data" 

date


