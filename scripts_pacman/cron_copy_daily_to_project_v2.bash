#!/bin/bash
#this script copy *.tif files in $WORKDIR/nps/yyyy/Ayyyyddd to project
#inputs: org_dir, des_dir, y_list
#example: 
#org_dir=$CENTER/nps/snow_metrics
#des_dir=/projects/UAFGINA/nps_snow/terra/daily
#y_list="2009 2010"

echo "begin copying *.tif files to /projects at `date`"

org_dir=$1
des_dir=$2
y_list=$3

#org_dir=/wrkdir/jzhu/nps/snow_metrics
#des_dir=/projects/UAFGINA/nps_snow/daily

for year in $y_list
do

if [ -d $org_dir/$year ]; then
mkdir -p $des_dir/$year/tif
cd $org_dir/$year
for subdir in `ls -d *`
do

if [ -f "$subdir/ok" ];then

mv $org_dir/$year/$subdir/*.tif $des_dir/$year/tif
rm -f -r $org_dir/$year/$subdir
fi

done


fi
done

echo "finish copying data at `date`"

exit 0
