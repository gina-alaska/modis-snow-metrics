#!/bin/bash
#jzhu,10/12/2011
#This program process one year daily snow data. It requsts a node for one day data, copy the one day data
#from /projects/UAFGINA/... to $WRKDIR/..... produces
#the daily data and save into /projects/UAFGINA/nps_snow/aqua/daily/yyyy/tif

#inputs:year,stday,edday,sat
#sat: terra, aqua

if [ $# != 4 ]; then
echo 
echo "this script takes four parameters:year,stday,edday,sat"
echo
exit 1
fi

year=$1
stday=$2
edday=$3
sat=$4

#set directories
wrk_dir=/wrkdir/jzhu/nps
wrk_data=$wrk_dir/daily/$year
prg_dir=$HOME/nps/cesu/snow_metrics/scripts
org_dir=/projects/UAFGINA/nps_snow/aqua/daily/$year
des_dir=/projects/UAFGINA/nps_snow/aqua/daily/$year/tif
log_dir=$wrk_dir/logs


rm $prg_dir/*.o*
rm $prg_dir/*.e*


#set up stout and stderr to a file
#LOG=$log_dir/$.db_main.log
#ERR=$LOG_DIR/$(basename $pds_file).db_main.err
#exec 1>$LOG 2>$ERR


cd $org_dir

ls -d A* > list

#list includes the subdirectory of a 8-day, for each of these subdirectory, 

cd $prg_dir

while read line 
do

day=`echo $line | cut -c6-8`

echo $day

if [ $day -ge $stday -a $day -le $edday ]; then

mkdir -p $wrk_data/$line

cp $org_dir/$line/*.hdf $wrk_data/$line

Ayyyyddd=$line

qsub -v year=$year,Ayyyyddd=$Ayyyyddd,sat=$sat process_aqua_one_dailysnow.pbs

fi


done < $org_dir/list

exit 0
