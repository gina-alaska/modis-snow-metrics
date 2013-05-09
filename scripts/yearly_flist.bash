#!/bin/bash
#this script accept user's inputs:dir_daily_snow,snow_year. produces yearly file name list,output:snow_year_file_list
#snow_year is defined as current 10/1 to next year 9/30

if [ $# != 3 ];then
echo
echo "inputs: dir_daily_snow,year, output_dir"
echo
exit 1
fi

dir_snow=$1
snow_year=$2
dir_output=$3
current_year=$snow_year
next_year=$(($snow_year + 1 ))
dir_tmp=$dir_snow/$snow_year

#if [ -d "$dir_tmp" ]; then 
#echo 
#echo " dir_daily_snow does not exist"
#echo
#exit 1
#fi


# remove the old flists

rm -f $dir_output/${snow_year}_flist_fract
rm -f $dir_output/${snow_year}_flist_cover
rm -f $dir_output/${snow_year}_flist_quali
rm -f $dir_output/${snow_year}_flist_albed

#determine if current_year is least year

let "cz=$current_year % 4"

let "nz=$next_year % 4"

if [ $cz -ne 0 -a $nz -ne 0 ]; then 
csday=274
ceday=365
nsday=1
neday=273
elif [ $cz -eq 0 -a $nz -ne 0 ]; then
csday=275
ceday=366 
nsday=1
neday=273
elif [ $cz -ne 0 -a $nz -eq 0 ]; then
csday=274
ceday=365
nsday=1
neday=274
fi

for tmp in `seq $csday $ceday`
do
ls $dir_snow/$current_year/A$current_year$tmp/*.Fractional_Snow_Cover.tif>>$dir_output/${snow_year}_flist_fract
ls $dir_snow/$current_year/A$current_year$tmp/*.Snow_Cover_Daily_Tile.tif>>$dir_output/${snow_year}_flist_cover
ls $dir_snow/$current_year/A$current_year$tmp/*.Snow_Spatial_QA.tif>>$dir_output/${snow_year}_flist_quali 
ls $dir_snow/$current_year/A$current_year$tmp/*.Snow_Albedo_Daily_Tile.tif>>$dir_output/${snow_year}_flist_albed
done


for tmp in `seq $nsday $neday`
do
ls $dir_snow/$next_year/A$next_year$tmp/*.Fractional_Snow_Cover.tif>>$dir_output/${snow_year}_flist_fract
ls $dir_snow/$next_year/A$next_year$tmp/*.Snow_Cover_Daily_Tile.tif>>$dir_output/${snow_year}_flist_cover
ls $dir_snow/$next_year/A$next_year$tmp/*.Snow_Spatial_QA.tif>>$dir_output/${snow_year}_flist_quali
ls $dir_snow/$next_year/A$next_year$tmp/*.Snow_Albedo_Daily_Tile.tif>>$dir_output/${snow_year}_flist_albed
done

exit 0







