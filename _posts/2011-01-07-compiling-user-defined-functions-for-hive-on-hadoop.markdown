---
redirect_to: https://bmuller.wtf
layout: post
title: "Compiling User Defined Functions for Hive on Hadoop"
date: 2011-01-07 18:55
categories: [hadoop, hive]
excerpt_separator: ""
---
While writing some fairly complicated [Hive](http://wiki.apache.org/hadoop/Hive) queries recently I decided to implement a section of the logic in the form of a custom [User Defined Function (UDF)](http://wiki.apache.org/hadoop/Hive/HivePlugins).  The instructions only cover creating the Java file and importing the compiled jar, but they do not cover a description of how to compile the UDF.  I spent a while trying to include the correct jar files in both the Hadoop and Hive build directories.  When I finally worked through all of the issues, I scripted the process, and I present that here for those poor souls who were in my position (I hate Java, btw):
{% highlight bash %}
#!/bin/bash

if [ "$1" == "" ]; then
   echo "Usage: $0 <java file>"
   exit 1
fi

CNAME=${1%.java}
JARNAME=$CNAME.jar
JARDIR=/tmp/hive_jars/$CNAME
CLASSPATH=$(ls $HIVE_HOME/lib/hive-serde-*.jar):$(ls $HIVE_HOME/lib/hive-exec-*.jar):$(ls $HADOOP_HOME/hadoop-core-*.jar)

function tell {
    echo
    echo "$1 successfully compiled.  In Hive run:"
    echo "$> add jar $JARNAME;"
    echo "$> create temporary function $CNAME as 'com.example.hive.udf.$CNAME';"
    echo
}

mkdir -p $JARDIR
javac -classpath $CLASSPATH -d $JARDIR/ $1 && jar -cf $JARNAME -C $JARDIR/ . && tell $1
{% endhighlight %}

This script is certainly not foolproof, so feel free to post corrections.  One other thing to note is that for **DoubleWritables** you should use the one in **org.apache.hadoop.hive.serde2.io.DoubleWritable** instead of **org.apache.hadoop.io.DoubleWritable** (otherwise Hive freaks out).
