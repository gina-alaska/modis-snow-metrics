#!/bin/bash

#copy one daily snow from /projects/UAFGINA/nps_snow/terra/daily/$year/$yyyy.mm.dd to $WORKDIR/nps/$year/$yyyy.mm.dd

year=$1

mm=$2

dd=$3

yyyymmdd=$year.$mm.$dd

org_dir="/projects/UAFGINA/nps_snow/terra/daily/$year/$yyyymmdd"

des_dir="$CENTER/nps/snow_metrics/$year/$yyyymmdd"

mkdir -p $des_dir

#find ${org_dir}/* -type f | batch_stage -i

#/usr/bin/rcp -rp "bigdip-s:${org_dir}/* ${des_dir}"

cp ${org_dir}/* ${des_dir}

date


