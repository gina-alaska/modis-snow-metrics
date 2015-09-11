#!/bin/bash
cdir=$PWD
ftp_server=ftp://n5eil01u.ecs.nsidc.org

org_dir=/SAN/MOST/MOD10A1.005

#des_dir=/mnt/jzhu_scratch/nps/snow_products/terra/daily/2013
#des_dir=/center/w/jzhu/nps/snow_metrics/
#yyyyymmdd is 2015.01.01 format

yyyymmdd=$1

yyyy=${yyyymmdd:0:4}

#des_dir=/center/w/jzhu/nps/snow_metrics/${yyyy}

des_dir=/home/jzhu4/data/snow_metrics/${yyyy}

mkdir -p $des_dir/${yyyymmdd}

tilenames=`cat <tile_names.txt`

#mkdir -p $des_dir/${yyyymmdd}
#cd $des_dir/${yyyymmdd}
#while read line; do
#echo downloading $line in $org_dir/${yyyymmdd}
#/u1/uaf/jzhu/apps/bin/lftp -e "mget $org_dir/${yyyymmdd}/*${line}*; quit" $ftp_server
#done < $cdir/tile_list

for i in $tilenames

do

#lftp -e "mirror $org_dir/${yyyymmdd} $des_dir/${yyyymmdd}; quit" $ftp_server

#lftp -e "mirror -P 10 $org_dir/${yyyymmdd} $des_dir/${yyyymmdd}; quit" $ftp_server

#dynamically form a lftp script"

echo "open $ftp_server">lftp_script.txt

echo "cd $org_dir/${yyyymmdd}" >>lftp_script.txt

echo "mget -c *$i* -O $des_dir/${yyyymmdd}" >>lftp_script.txt

echo "quit" >>lftp_script.txt


lftp -f lftp_script.txt

rm lftp_script.txt

done

cd $cdir
