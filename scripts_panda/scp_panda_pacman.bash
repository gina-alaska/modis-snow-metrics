#!/bin/bash
#copy data from panda to pacman


src_dir=/mnt/raid/data/snow_metrics/2015

des_dir=/center/w/jzhu/nps/snow_metrics/2015


cd $src_dir

ls -d 2015.*.* >dlist

while read line
do 

rsync -avrze ssh $line/*.tif jzhu@pacman13.arsc.edu:$des_dir/$line



done < dlist
