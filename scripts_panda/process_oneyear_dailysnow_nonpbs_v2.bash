#!/bin/bash
#jzhu,10/12/2011
#This program process one year daily snow data. one year daily data have already been 
#saved in /wrkdir/jzhu/nps/yyyy. It requsts a node for each daily data, produces
#the daily data and save into /projects/UAFGINA/nps_snow/daily/yyyy/tif

#inputs:year,stday,edday

if [ $# != 3 ]; then
echo 
echo "this script takes three parameters:year,stday,edday"
echo
exit 1
fi

year=$1
stdate=$2  #yyyymmdd
eddate=$3   #yyyymmdd

styr=${stdate:0:4}
stmm=${stdate:4:2}
stdd=${stdate:6:2}


edyr=${eddate:0:4}
edmm=${eddate:4:2}
eddd=${eddate:6:2}



#set directories
wrk_dir=/center/w/jzhu/nps/snow_metrics
wrk_data=/center/w/jzhu/nps/snow_metrics/$year
prg_dir=$HOME/nps/cesu/snow_metrics/scripts
org_dir=/center/w/jzhu/nps/snow_metrics
des_dir=/center/w/jzhu/nps/snow_metrics/$year/tif
log_dir=$wrk_data/logs
err_dir=$wrk_data/errors

mkdir -p $log_dir
mkdir -p $err_dir

cur_date=`date +%Y%m%d-%H%M%S`

#set up stout and stderr to a file

LOG=$log_dir/oneyear_mosaic_resample_${cur_date}.log
ERR=$err_dir/oneyear_mosaic_resample_${cur_date}.err
exec 1>$LOG 2>$ERR


cd $org_dir/$year

ls -d ${year}* > list

#list includes the subdirectory of a 8-day, for each of these subdirectory, 

cd $prg_dir

while read line 
do

yyyy=`echo $line | cut -c1-4`
mm=`echo $line | cut -c6-7`
dd=`echo $line | cut -c9-10`

echo $line

if [ $yyyy$mm$dd -ge  $styr$stmm$stdd -a $yyyy$mm$dd -le $edyr$edmm$eddd ]; then

#mkdir -p $wrk_data/$line
#cp $org_dir/$line/*.hdf $wrk_data/$line


#yyyy=`echo $line | cut -c1-4`
#mm=`echo $line | cut -c6-7`
#dd=`echo $line | cut -c9-10`

#qsub -v year=$year,mm=$mm,dd=$dd $HOME/nps/cesu/snow_metrics/scripts/Grid_one_dailysnow_v2.pbs

$prg_dir/Grid_one_dailysnow_v2.bash $org_dir $year $mm $dd

fi


done < $org_dir/$year/list

echo "done the process!"

exit 0
