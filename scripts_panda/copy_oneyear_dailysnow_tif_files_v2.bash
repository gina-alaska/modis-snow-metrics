#!/bin/bash
org_dir=/center/w/jzhu/nps/snow_metrics/2013
des_dir=/center/w/jzhu/nps/snow_metrics/2013/tif

while read line 
do
yyyy=`echo $line | cut -c1-4`
mm=`echo $line | cut -c6-7`
dd=`echo $line | cut -c9-10`
cp $org_dir/$yyyy.$mm.$dd/*.tif $des_dir
done < $org_dir/list
exit 0
