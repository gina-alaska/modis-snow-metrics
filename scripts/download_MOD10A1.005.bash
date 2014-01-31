#!/bin/bash
cdir=$PWD
ftp_server=ftp://n5eil01u.ecs.nsidc.org
org_dir=/SAN/MOST/MOD10A1.005/
des_dir=/mnt/jzhu_scratch/nps/snow_products/terra/daily/2013
yyyymmdd=$1

lftp -e "mirror $org_dir/${yyyymmdd} $des_dir/${yyyymmddd}; quit" $ftp_server
