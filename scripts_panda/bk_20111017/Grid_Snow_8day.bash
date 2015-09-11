#!/bin/bash --debugger
#jzhu,9/30/2011, modify from Grid_Snow.csh, it produce 8-day files.and save the output files in $dir_prod/YYYY/A8dyyyyddd
#input: dir_data, dir_prod
#ouput: files of a year

#for example: dir_data=/mnt/pod/snow_products/original/8_Day_Snow_Products/2010
#             dir_prod=/mnt/pod/snow_products/8day/2010


#check if ou input correct parameters

if [ $# != 2 ]; then 

echo
echo "this script take two parameters: dir_data dir_prod"
echo
exit 1
fi

dir_data=$1
dir_prod=$2

if [ ! -d "$dir_data" ]; then 
echo
echo "the data directory does not exist"
echo
exit 1
fi

#create a product directory

mkdir -p $dir_prod

#change to $dir_data

cd $dir_data

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



echo $cdir/MOD10A?.$line.*.hdf > tmp.$day


done < satyyyyddd


#make file names of the file list unique
echo "make file names of the file list unique"

for jday in `ls tmp.??? | cut -c5-7`
do

echo $jday
cat tmp.$jday | sort -u > $year-$jday
done

/bin/rm tmp.???


#doing Making Mosaics and resample

echo "doing mosaic and resample"

for item in $year-*
do
echo $item
mrtmosaic -i $item -o $item.hdf
echo "INPUT_FILENAME = $cdir/$item.hdf" > K.prm
echo "SPECTRAL_SUBSET = ( 1 1 1 1 )" >> K.prm
echo "SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG" >> K.prm
echo "SPATIAL_SUBSET_UL_CORNER = ( 71.5 -179.9 )" >> K.prm
echo "SPATIAL_SUBSET_LR_CORNER = ( 50.5 -129.5 )" >> K.prm
echo "OUTPUT_FILENAME = $cdir/Test.tif" >> K.prm
echo "RESAMPLING_TYPE = NEAREST_NEIGHBOR" >> K.prm
echo "OUTPUT_PROJECTION_TYPE = AEA" >> K.prm
echo "OUTPUT_PROJECTION_PARAMETERS = ( 0.0 0.0 65.0 55.0 -154.0 50.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 )" >> K.prm
echo "DATUM = NAD83" >> K.prm
echo "OUTPUT_PIXEL_SIZE = 500" >> K.prm

sed s/Test.tif/$item.tif/ < K.prm > $item.prm
resample -p $item.prm
mv $item.*.tif $dir_prod
/bin/rm $item.*.tif
/bin/rm $item.hdf 

done

exit

