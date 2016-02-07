---
layout: post
title: OS X Say Command on Linux
categories: [linux, os_x]
---
So all the cool cats on Macs think they're the only ones who can make their computers talk with the 
[say command](http://guides.macrumors.com/say).  Now, Linux users too can have this power using an unpublished
Google tranlsate API call.  Just put this in your *.bashrc* file:

{% highlight bash %}
function say { mplayer -really-quiet "http://translate.google.com/translate_tts?tl=en&q=$1"; }
{% endhighlight %}

Then, it's easy as pie to make your computer talk:
{% highlight bash %}
say "Linux users do not have to pay lots of money to make their computers do cool stuff"
{% endhighlight %}