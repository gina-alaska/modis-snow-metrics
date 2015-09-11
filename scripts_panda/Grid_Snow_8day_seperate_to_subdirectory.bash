#!/bin/bash
#jzhu,10/12/2011, this program seperate one-year 8-day data into seperated directories
#input: dir_data, year,dir_prod

#for example: dir_data=/mnt/pod/snow_products/original/8_Day_Snow_Products
#year=2010
#dir_prod=/mnt/pod/snow_products/8day


if [ $# != 3 ]; then 

echo
echo "this script take three parameters: dir_data year dir_prod"
echo
exit 1
fi

dir_data=$1
year=$2
dir_prod=$3

if [ ! -d "$dir_data/$year" ]; then 
echo
echo "the data directory does not exist"
echo
exit 1
fi

#create a product directory

mkdir -p $dir_prod/$year

#change to $dir_data

cd $dir_data/$year

cdir=$PWD 

/bin/rm -f tmp*
/bin/rm -f satyyyyddd

#product file list of each day, one day has its file list called tmp.DDD

ls M*.hdf |cut -c9-16 |sort|uniq>satyyyyddd

while read line  
do 
echo $line

 sat=`echo $line | cut -c1-1`
year=`echo $line | cut -c2-5`
 day=`echo $line | cut -c6-8`

##case $sat in
##        A)
##        SAT=t1; 
##        P)
##        SAT=a1;
##esac
mkdir -p $dir_prod/$year/$line

mv $cdir/MOD10A?.$line.*.hdf $dir_prod/$year/$line

echo $dir_prod/$year/$line/MOD10A?.$line.*.hdf |sort -u >$dir_prod/$year/$line/$year-$day

done < satyyyyddd

exit 0

