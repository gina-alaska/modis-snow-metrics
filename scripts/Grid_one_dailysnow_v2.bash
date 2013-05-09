#!/bin/bash
#jzhu,11/18/2011, modify from Grid_Snow.csh, it produce one daily files and save the output files in $dir_prod/YYYY/A8dyyyyddd
#input: dir_data, year, Ayyyyddd
#ouput: $dir_prod/$year/$Ayyyyddd/done

#for example: dir_data=/wrkdir/jzhu/npis/daily
#             year=2010
#             mm=01
#             dd=01
#             

#check if ou input correct parameters

#include environment variables for mrt

. $HOME/nps/cesu/snow_metrics/scripts/setup


if [ $# != 4 ]; then 

echo
echo "this script take four parameters: dir_data year mm dd"
echo
exit 1
fi

dir_data=$1
year=$2
mm=$3
dd=$4

if [ ! -d "$dir_data/$year/${year}.${mm}.${dd}" ]; then 
echo
echo "the data directory does not exist"
echo
exit 1
fi


#create a product directory

#mkdir -p $dir_prod

#change to $dir_data

cd $dir_data/$year/${year}.${mm}.${dd}

cdir=$PWD 

/bin/rm -f *.lst
/bin/rm -f $year-$mm-$dd
/bin/rm -f $year-$mm-${dd}.hdf

#product file list of each day, one day has its file list called tmp.DDD

for tile in `cat < ../../tile_names.txt`
do
x=`find $cdir -name MOD10A?.\*${tile}\*.hdf`
if [ ! -z $x ];then
echo $cdir/MOD10A?.*${tile}*.hdf | sort -u >> $year-$mm-$dd
fi
done

#doing Making Mosaics and resample

echo "doing mosaic and resample"

item=$year-$mm-$dd

mrtmosaic -i $item -o $item.hdf
echo "INPUT_FILENAME = $cdir/$item.hdf" > K.prm
echo "SPECTRAL_SUBSET = ( 1 1 1 1 )" >> K.prm
echo "SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG" >> K.prm
echo "SPATIAL_SUBSET_UL_CORNER = ( 71.5 -179.9 )" >> K.prm
echo "SPATIAL_SUBSET_LR_CORNER = ( 50.5 -129.5 )" >> K.prm
echo "OUTPUT_FILENAME = $cdir/Test.tif" >> K.prm
echo "RESAMPLING_TYPE = NEAREST_NEIGHBOR" >> K.prm
echo "OUTPUT_PROJECTION_TYPE = AEA" >> K.prm
echo "OUTPUT_PROJECTION_PARAMETERS = ( 0.0 0.0 55.0 65.0 -154.0 50.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 )" >> K.prm
echo "DATUM = NAD83" >> K.prm
echo "OUTPUT_PIXEL_SIZE = 500" >> K.prm

sed s/Test.tif/$item.tif/ < K.prm > $item.prm
resample -p $item.prm

#if [ -a "$cdir/*.tif" ];then
touch $cdir/ok
#/bin/rm $item.hdf 
#/bin/rm *.hdf
#fi

exit

