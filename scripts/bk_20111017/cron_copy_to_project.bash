#!/bin/bash
#this script copy *.tif files in $WORKDIR/nps/yyyy/Ayyyyddd to project
echo "begin copying *.tif files to /projects at `date`"
org_dir=/wrkdir/jzhu/nps
des_dir=/projects/UAFGINA/nps_snow/8day

for year in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010
do

if [ -d $org_dir/$year ]; then

cd $org_dir/$year
mkdir -p $des_dir/$year/done
for subdir in `ls -d A*`
do

if [ -f "$subdir/ok" ];then

mv $org_dir/$year/$subdir/*.tif $des_dir/$year/done
rm -f -r $org_dir/$year/$subdir
fi

done


fi
done

echo "finish copying data at `date`"

exit 0
