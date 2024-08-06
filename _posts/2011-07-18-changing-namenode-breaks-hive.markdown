---
redirect_to: https://bmuller.wtf
layout: post
title: "Changing Namenode Hostname Breaks Hive"
date: 2011-07-18 18:50
categories: [ hive, hadoop ]
---
[Hive](http://wiki.apache.org/hadoop/Hive) is a great piece of software - but there are still some major issues.  I ran into one recently when I changed the hostname of 
the Hadoop namenode.  I couldn't figure out why hive was using the old hostname, even after changing all of the config files in the **$HADOOP_HOME** to use the new one 
and testing other map/red jobs.

Apparently, Hive stores all partition information with full references to the location (for instance, *hdfs://host:9000/user/hive/warehouse/some/path*).
This makes lookups faster in the metastore, but makes it impossible to easily change the hostname of your namenode.

The best way I could find to do this was the following:
1. **mysqldump** the metadata database to a local file
1. Edit the dump and do a global search and replace on any instances of the old hostname
1. Reimport the dump

If the location was saved in a separate table (w/ a one to many relationship between partitions and hosts / locations) it would make this process quite a bit easier.