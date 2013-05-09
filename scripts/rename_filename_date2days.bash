#!/bin/bash
#this script accept user's inputs:f_dir
#rename the filename from with date to with days of year

wrk_dir=$PWD

if [ $# != 1 ];then
echo
echo "inputs:f_dir"
echo
exit 1
fi
f_dir=$1

cd $f_dir

ls ????-??-??.*.tif>flist

while read tmp
do

year=${tmp:0:4}
month=${tmp:5:2}
day=${tmp:8:2}
p=${#tmp}  #length of string

num=$(($p-10))
f_affix=${tmp:10:num}

python $wrk_dir/convert_date_daysofyear.py $year $month $day

read days <daysofyear

echo "mv $tmp ${year}-${days}${f_affix}"

mv $tmp ${year}-${days}${f_affix}

done <flist

rm -f daysofyear
rm -f flist

exit 0







