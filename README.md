# mysql-bu-script

Simple backup script which reads out your Databases and makes single dumps per database for you.

This is something that I still have running on a few servers. I obviously had some extra time in
2015 as you can tell on some of the ASCII art in the script. Sorry for that.

I have enough comments in the scripts to guide you through my thoughts
so it should not be too hard to follow along if you need to debug something.

## how to use

1. Copy both files to your server. 
   
2. Run the prepare_mysql_backup.sh and answer all the questions.

3. Add a cronjob for the resulting mysql_multi_backup.sh which you will find
    wherever you told the script to place it.

Done.

## default structure

If you stick to the defaults you will find everything under /data/backup on your machine.


