---
redirect_to: https://bmuller.wtf
layout: post
title: "HiveSwarm: Additional User Defined Functions for Hive"
date: 2011-04-09 16:17
categories: [hive, hadoop]
redirect_from:
  - /hive/hadoop/2011/04/09/hiveswarm:-additional-user-defined-functions-for-hive.html
---
There are a number of user defined functions that would be quite useful in Hive but that have not been created and added to the library.  Hive does provide the ability to define custom functions, but, as I've [noted before](/hadoop/hive/2011/01/07/compiling-user-defined-functions-for-hive-on-hadoop.html), the documentation is sparse and sometimes simply wrong.  For instance, the instructions for createing a user defined table generating function (found [here](http://wiki.apache.org/hadoop/Hive/DeveloperGuide/UDTF)) incorrectly show the *close* method calling *forward* which will cause an error when you try to run the function in even Hive 0.5.0.

In an effort to both collect useful functions that we are writing at [LivingSocial](http://livingsocial.com) as well as to make the compiling process easier, we've created a new open source project on Github called [HiveSwarm](https://github.com/livingsocial/HiveSwarm).  There are only a few functions there now, but more and more functions will be added over time.  

<table>
  <tr class="thead">
    <td>server</td>
    <td>page_load</td>
  </tr>
  <tr>
    <td>10.0.0.1</td><td>2011-04-01 10:01:01</td>
  </tr>
  <tr>
    <td>10.0.0.1</td><td>2011-04-01 10:01:05</td>
  </tr>
  <tr>
    <td>10.0.0.1</td><td>2011-04-01 10:03:00</td>
  </tr>
  <tr>
    <td>10.0.0.2</td><td>2011-04-01 10:01:02</td>
  </tr>
  <tr>
    <td>10.0.0.2</td><td>2011-04-01 10:01:05</td>
  </tr>
</table>

One of the most useful new functions is called **intervals**.  The function will generate a table with the intervals between values in an input table.  For instance, let's say you have a table that has one column for server IP addresses and another that has dates and times for page loads (shown in the table on the left).  Imagine you wish to know the intervals between page loads per server.

After compiling [HiveSwarm](https://github.com/livingsocial/HiveSwarm), you can load the jar and add the function:
{% highlight sql %}
add jar /path/to/HiveSwarm.jar;
create temporary function intervals as 'com.livingsocial.hive.udtf.Intervals';
{% endhighlight %}

Then, to select the intervals, just specify the grouping column and the column you wish to get intervals from:
{% highlight sql %}
select intervals(server, page_load) as (server, intervals) from server_page_loads;
{% endhighlight %}

This will produce the results shown in the second table (with intervals in seconds).

<table>
  <tr class="thead">
    <td>server</td>
    <td>intervals</td>
  </tr>
  <tr>
    <td>10.0.0.1</td><td>4.0</td>
  </tr>
  <tr>
    <td>10.0.0.1</td><td>115.0</td>
  </tr>
  <tr>
    <td>10.0.0.2</td><td>3.0</td>
  </tr>
</table>

The column to pull intervals from can be either numeric or a string type.  If it is a string, then it will be converted into a timestamp (so the resulting difference will be calculated in seconds).  All numberical types (including timestamps from strings) will be converted into floats.

Pull requests are welcomed if you have a function you'd like to see added.  

Additional information can be found on the [github page](https://github.com/livingsocial/HiveSwarm).