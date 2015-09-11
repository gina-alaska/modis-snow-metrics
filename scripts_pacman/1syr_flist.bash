#!/bin/bash
#this script accept user's inputs:dir_daily_snow,snow_year,output_dir. produces yearly file name list,output:snow_year_file_list
#snow year is named by the year which they end, so 2010 snowyear means from 2009/8/1 to 2010/7/31.

#if snow_year is defined as current 10/1 to next year 9/30, st_days=274, ed_days=273,
#if snow_year is defined as 8/1 to 7/31, then st_days=213, ed_days=212

if [ $# != 3 ];then
echo
echo "inputs:dir_daily_snow,year,output_dir"
echo
exit 1
fi

dir_snow=$1
snow_year=$2
#for a no-leap year, 8/1 =213 days of the year, 7/31=212 dyas of year
st_day=213
ed_day=212
dir_output=$3


current_year=$(($snow_year -1))
next_year=$snow_year

dir_tmp=$dir_snow/$snow_year

affix="tif"


#if [ -d "$dir_tmp" ]; then 
#echo 
#echo " dir_daily_snow does not exist"
#echo
#exit 1
#fi

#create the directory if it is not exist

dir_output1=${dir_output}/${snow_year}

if [ -d "${dir_output1}" ] 
then
# remove the old flists

rm -f $dir_output1/${snow_year}_flist_fract
rm -f $dir_output1/${snow_year}_flist_cover
rm -f $dir_output1/${snow_year}_flist_quali
rm -f $dir_output1/${snow_year}_flist_albed
else
mkdir -p $dir_output1
fi


#determine if current_year is least year

let "cz=$current_year % 4"

let "nz=$next_year % 4"

if [ $cz -ne 0 -a $nz -ne 0 ]; then 
csday=$st_day
ceday=365
nsday=1
neday=$ed_day
elif [ $cz -eq 0 -a $nz -ne 0 ]; then
csday=$(($st_day +1))
ceday=366 
nsday=1
neday=$ed_day
elif [ $cz -ne 0 -a $nz -eq 0 ]; then
csday=$st_day
ceday=365
nsday=1
neday=$(($ed_day+1))
fi

for tmp in `seq -w $csday $ceday`
do
ls $dir_snow/$current_year/$affix/$current_year-$tmp*.Fractional_Snow_Cover.tif>>$dir_output1/${snow_year}_flist_fract
ls $dir_snow/$current_year/$affix/$current_year-$tmp*.Snow_Cover_Daily_Tile.tif>>$dir_output1/${snow_year}_flist_cover
ls $dir_snow/$current_year/$affix/$current_year-$tmp*.Snow_Spatial_QA.tif>>$dir_output1/${snow_year}_flist_quali 
ls $dir_snow/$current_year/$affix/$current_year-$tmp*.Snow_Albedo_Daily_Tile.tif>>$dir_output1/${snow_year}_flist_albed
done


for tmp in `seq -w $nsday $neday`
do
ls $dir_snow/$next_year/$affix/$next_year-$tmp*.Fractional_Snow_Cover.tif>>$dir_output1/${snow_year}_flist_fract
ls $dir_snow/$next_year/$affix/$next_year-$tmp*.Snow_Cover_Daily_Tile.tif>>$dir_output1/${snow_year}_flist_cover
ls $dir_snow/$next_year/$affix/$next_year-$tmp*.Snow_Spatial_QA.tif>>$dir_output1/${snow_year}_flist_quali
ls $dir_snow/$next_year/$affix/$next_year-$tmp*.Snow_Albedo_Daily_Tile.tif>>$dir_output1/${snow_year}_flist_albed
done

exit 0







