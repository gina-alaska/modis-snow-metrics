#!/bin/bash
#jzhu,10/12/2011
#This program process one year 8day snow data.one year 8-day data have already been 
#saved in /wrkdir/jzhu/nps/yyyy. It requsts a node for each 8-day data, produces
#the 8-day data and save into /projects/UAFGINA/nps_snow/8day/yyyy/done

#inputs:year,stday,edday

if [ $# != 3 ]; then
echo 
echo "this script takes three parameters:year,stday,edday"
echo
exit 1
fi

year=$1
stday=$2
edday=$3


#set directories
wrk_dir=/wrkdir/jzhu/nps
wrk_data=$wrk_dir/$year
prg_dir=$HOME/nps/cesu/snow_metrics/scripts
org_dir=/projects/UAFGINA/nps_snow/8day/$year
des_dir=/projects/UAFGINA/nps_snow/8day/$year/done
log_dir=$wrk_dir/logs

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

qsub -v year=$year,Ayyyyddd=$Ayyyyddd process_one_8daysnow.pbs

fi


done < $org_dir/list

rm $prg_dir/*.o*
rm $prg_dir/*.e*

exit 0
