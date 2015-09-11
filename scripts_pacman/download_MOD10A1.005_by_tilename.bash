#!/bin/bash
cdir=$PWD
ftp_server=ftp://n5eil01u.ecs.nsidc.org

org_dir=/SAN/MOST/MOD10A1.005

#des_dir=/mnt/jzhu_scratch/nps/snow_products/terra/daily/2013
#des_dir=/center/w/jzhu/nps/snow_metrics/

yyyymmdd=$1

yyyy=${yyyymmdd:0:4}

des_dir=/center/w/jzhu/nps/snow_metrics/${yyyy}

tilenames=`cat <tile_names.txt`

#mkdir -p $des_dir/${yyyymmdd}
#cd $des_dir/${yyyymmdd}
#while read line; do
#echo downloading $line in $org_dir/${yyyymmdd}
#/u1/uaf/jzhu/apps/bin/lftp -e "mget $org_dir/${yyyymmdd}/*${line}*; quit" $ftp_server
#done < $cdir/tile_list

for i in $tilenames

do

echo $i

/u1/uaf/jzhu/apps/bin/lftp -e "mirror -I *$i* $org_dir/${yyyymmdd} $des_dir/${yyyymmdd}; quit" $ftp_server

#/u1/uaf/jzhu/apps/bin/lftp -e "mget $org_dir/${yyyymmdd}/*${i}* -O $des_dir/${yyyymmdd}; quit" $ftp_server

done

cd $cdir
