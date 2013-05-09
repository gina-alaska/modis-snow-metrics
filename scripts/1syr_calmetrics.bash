#!/bin/bash
#this script calcualte metrics for one snowyear stacked file.
#input: a one-snowyear file name
#outputs: a smooth data file and a metrics file.


if [ $# != 4 ];then

echo "input four one-snowyear-daily_snow_stack files"

exit 1

fi

#load environment variabels

source ./1syr_env.bash

#cd $idlprg_dir

filen_cover=$1
filen_fract=$2
filen_quali=$3
filen_albed=$4

ver='v7'
flg=0


fd=`dirname $filen_cover`

#Send output to logfile
LOG=$fd/calculate-metrics.log
exec >>$LOG
exec 2>>$LOG

echo "________________________"

#send start time

echo calculating snow-metrics started at `date -u`

idl_curr='/usr/local/pkg/idl/idl-8.2/idl/bin/idl'

$idl_curr<<EOF
restore,filename='/u1/uaf/jzhu/nps/cesu/snow_metrics/sav/code.sav'
smooth_calculate_snowmetrics_tile_terra_only,'$filen_cover','$filen_fract','$filen_quali','$filen_albed','$ver','$flg'
exit
EOF

#Send end time

echo "________________________"

echo $0 ended at `date -u`

exit
