#!/bin/bash
#this script produces an one-snowyear-stacked files
#inputs: flist_cover, flist_fract,flist_quali,flist_albed,ul_lon,ul_lat,lr_lon,lr_lat
#output:one-snow-year-stacked file
#example inputs:
#ul_lon= meters, ul_lat= meters
#lr_lon= meters, lr_lat= meters
#if do not want subsize, input: 0,0,0,0 for four conor cooordinates


#check if input parameters are correct

source ./1syr_env.bash

if [ $# != 8 ];then
echo
echo "input flist_cover,flist_fract,flist_quali,flist_albed,ul_lon,ul_lat,lr_lon,lr_lat"
echo
exit 1
fi

flist_cover=$1
flist_fract=$2
flist_quali=$3
flist_albed=$4
ul_lon=$5
ul_lat=$6
lr_lon=$7
lr_lat=$8


#cd $idlprg_dir

#/usr/local/pkg/idl/idl-7.1/idl71/bin/idl <<EOF
#restore,filename='/u1/uaf/jzhu/nps/cesu/modis_ndvi_metrics/sav/codes.sav'
#oneyear_data_layer_subset_good, '$flist_ndvi','$flist_bq','$ul_lon','$ul_lat', '$lr_lon','$lr_lat'
#oneyear_snowdata_layer_subset,flist_cover, flist_fract,flist_quali,flist_albed, ul,lr
#exit
#EOF

/usr/local/pkg/idl/idl-8.2/idl/bin/idl <<EOF
restore,filename='/u1/uaf/jzhu/nps/cesu/modis_snow_metrics_v1.0/sav/code.sav'
oneyear_snowdata_layer_subset,'$flist_cover', '$flist_fract','$flist_quali','$flist_albed', '$ul_lon','$ul_lat','$lr_lon','$lr_lat'
exit
EOF

exit 0  


