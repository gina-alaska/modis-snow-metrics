#!/bin/bash
#input: snow_year 

snow_year=$1

source ./1syr_env.bash

#dir_raw="/projects/UAFGINA/nps_snow/terra/daily"

#dir_out="/center/w/jzhu/nps/snow-metrics"

#copy raw files into work_dir

pre_year=$(($snow_year -1))

mkdir -p $work_dir/${snow_year}/tif

mkdir -p $work_dir/${pre_year}/tif

if [ `find ${work_dir}/${snow_year}/tif -type d -empty` ];then
./1syr_stage.bash ${rawdata_dir}/${snow_year}/tif $work_dir/${snow_year}/tif

fi

if [ `find ${work_dir}/${pre_year}/tif -type d -empty`  ];then

./1syr_stage.bash ${rawdata_dir}/${pre_year}/tif $work_dir/${pre_year}/tif

fi

#if snow_year=2011,2012, need rename the files

if [ ${pre_year} -ge 2011 ];then

./rename_filename_date2days.bash ${work_dir}/${pre_year}/tif

fi

#if [ ${snow_year} -gt 2012 ]; then

#./rename_filename_date2days.bash ${work_dir}/${snow_year}/tif

#if


#create file lists.

./1syr_flist.bash ${work_dir} $snow_year $work_dir

dir_wrk=$work_dir/$snow_year

./1syr_stack.bash $dir_wrk/${snow_year}_flist_cover $dir_wrk/${snow_year}_flist_fract $dir_wrk/${snow_year}_flist_quali $dir_wrk/${snow_year}_flist_albed 0 0 0 0

./1syr_calmetrics.bash $dir_wrk/${snow_year}_snow_cover $dir_wrk/${snow_year}_snow_fract $dir_wrk/${snow_year}_snow_quali $dir_wrk/${snow_year}_snow_albed 
