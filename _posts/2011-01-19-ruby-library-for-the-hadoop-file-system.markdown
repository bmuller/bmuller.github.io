---
redirect_to: https://bmuller.wtf
layout: post
title: "Ruby Library for the Hadoop File System (HDFS)"
date: 2011-01-19 15:28
categories: [hdfs, ruby, ganapati]
---
One of my current tasks is figuring out how to best get data out of Hadoop and into a MySQL database.  The fastest way to do that is to copy the Hive database files to the DB machine, concatenate them into one file, and then load the file into MySQL.  My thought at this point is that it is going to be best if I can traverse / query / download from the Hadoop file system using Ruby.

The only Ruby library that I could find that provided communication with Hadoop's distributed file system (HDFS) required Java, libhdfs, and a few other libraries and provided an incomplete interface (you can find the lib [here](https://github.com/alexstaubo/ruby-hdfs)).  My next step was to see how hard it would be to use the thrift interface.  What I found is that the documentation for the server is terrible (you can read it [here](http://wiki.apache.org/hadoop/HDFS-APIs)) and that the ruby thrift gem used to create the distributed library was created with one of the first versions (from Feb 2010).

The first step was to make the process of compiling and starting the Java Thrift server as painless as possible.  The result of that effort can be found in [this script](https://github.com/livingsocial/ganapati/blob/master/bin/hdfs_thrift_server), which compiles the server jar if it doesn't exist already and then starts the server on whatever port you pass in:
{% highlight bash %}
$> ./hdfs_thrift_server 8181
{% endhighlight %}

The only requirement is that you have your **$HADOOP_HOME** environment variable set correctly.

The next step was to actually build a usable gem wrapper around the generated (or, in this case, regenerated with the latest version of thrift) ruby code.  I decided to use one of [Ganesha](http://en.wikipedia.org/wiki/Ganesha)'s names - Ganapati - for the name of this project.  The usage is really simple:
{% highlight ruby %}
require 'rubygems'
require 'ganapati'

# args are host, port, and optional timeout
client = Ganapati::Client.new 'localhost', 1234

# copy a file to hdfs
client.put("/some/file", "/some/hadoop/path")

# get a file from hadoop
client.get("/some/hadoop/path", "/local/path")

# Create a file with code block
client.create("/home/someuser/afile.txt") { |f|
  f.write("this is some text")
}

# Open a file for reading and read it
client.open('/home/someuser/afile.txt') { |f|
    puts f.read
}
{% endhighlight %}

More examples and the project code can be found at [https://github.com/livingsocial/ganapati](https://github.com/livingsocial/ganapati).