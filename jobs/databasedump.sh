#! /bin/bash

pw=$1
if [ "$pw" = "" ]
then
  echo "No password was supplied. Exiting."
  exit
fi

corefile=mlgb-database-dump.sql
datetime=$(date +"%Y-%m-%d-%H%M")

dumpfilename="$datetime-$corefile"
dumpdir=/home/mlgb/sites/mlgb/parts/BACKUPS

echo "Dumping MLGB database to $dumpdir/$dumpfilename"
mysqldump -umlgbAdmin -p$pw --default-character-set=utf8 mlgb > $dumpdir/$dumpfilename 2>&1

cd $dumpdir

filecount=$((0))
keep=$((30))

#keep=$((1))

echo "Cleaning up old dump files... Will keep $keep copies."
for the_file in $(ls -t *$corefile)
do
  filecount=$(($filecount+1))
  echo "$filecount $the_file"
  if [ $filecount -gt $keep ]
  then 
    echo "Will not keep $the_file, it is too old"
    \rm $the_file
  fi
done
