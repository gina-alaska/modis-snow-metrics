#!/bin/bash

if [ $# != 1 ]; then
echo "input year(yyyy)"
exit 1
fi
year=$1
org_dir=/center/w/jzhu/nps/snow_metrics/$year
des_dir=/center/w/jzhu/nps/snow_metrics/$year/tif

cdir=$PWD

cd $org_dir

ls -d ${year}.*.* > list

while read line 
do
yyyy=`echo $line | cut -c1-4`
mm=`echo $line | cut -c6-7`
dd=`echo $line | cut -c9-10`
cp $org_dir/$yyyy.$mm.$dd/*.tif $des_dir
done < $org_dir/list

cd $cdir

exit 0
