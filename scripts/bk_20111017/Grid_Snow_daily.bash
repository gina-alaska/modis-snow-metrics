#!/bin/bash
#jzhu,9/30/2011, modify from Grid_Snow.csh, because we can use bashdb to debug *.bash easily
#input: dir_data, dir_prod
#ouput: files of a year

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

/bin/rm tmp*

#product file list of each day, one day has its file list called tmp.DDD

for file in  M*.hdf  
do 

sat=`echo $file | cut -c9-9`
year=`echo $file | cut -c10-13`
day=`echo $file | cut -c14-16`
echo $file

##case $sat in
##        A)
##        SAT=t1; 
##        P)
##        SAT=a1;
##esac

echo $sat$year$day
echo $cdir/MOD10A?.$sat$year$day.*.hdf > tmp.$day

done

#make file names of the file list unique

for jday in `ls tmp.??? | cut -c5-7`
do

echo $jday
cat tmp.$jday | sort -u > $year-$jday
done

/bin/rm tmp.???


#doing Making Mosaics and resample

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
mv $item.tif $dir_prod
/bin/rm $item
/bin/rm $item.hdf 

done

exit

