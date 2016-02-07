---
layout: post
title: Hue Behind HTTPS Proxy
categories: [hadoop, hue]
---
One of the things I've been working on lately is getting [Hue](https://github.com/cloudera/hue) (a browser based interface to [Hadoop](http://hadoop.apache.org/)) 
up and running in front of [LivingSocial](http://livingsocial.com)'s cluster.  One of the biggest problems was getting it to run without issues behind an nginx
proxy that provides an SSL (https) wrapper.  At first it seems to run fine, until you try to open the file browser or try to look at your Hive tables.  At that
point, you get an error that says:
{% highlight bash %}
The Hue server can not be reached. (Is the server running ?)
{% endhighlight %}
It took a while to track down the issue, but the problem actually resides with Django (which is what the web interface was written in).  Django rewrites
the **Location** header to make it absolute right before it writes out a 302 redirect response.  When it creates the absolute path, it automatically assumes that the 
protocol is HTTP.  This has been [a bug](http://code.djangoproject.com/ticket/6548) for over 3 years.  The only way to get Hue to redirect appropriately to 
a HTTPS location is to:

 1. Edit the file {% highlight bash %} /build/env/lib/python2.6/site-packages/Django-1.1.1-py2.6.egg/django/core/handlers/base.py {% endhighlight %} and remove the location fix from the *BaseHander.response_fixes* property.
 2. Modify your proxy to rewrite the protocol in the Location header for 302 responses.

In the end, we opted for #2.  It was easier than having to patch django each time we upgrade Hue.
