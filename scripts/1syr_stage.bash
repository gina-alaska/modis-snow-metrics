#!/bin/bash
#PBS -q transfer
#PBS -l walltime=8:00:00
#PBS -l nodes=1:ppn=1
#PBS -j oe

#cd $PBS_O_WORKDIR

#this script accept user's inputs:src_dir,des_dir. batch_stage the files from src_dir to des_dir
if [ $# != 2 ];then
echo
echo "inputs:dir_daily_snow,output_dir"
echo
exit 1
fi

src_dir=$1
des_dir=$2

#batch stage the files

batch_stage -r $src_dir

cp -r $src_dir/* $des_dir

exit 0

