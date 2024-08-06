---
redirect_to: https://bmuller.wtf
layout: post
title: "Genderator: Gender from First Name with Python"
date: 2012-06-23 13:19
categories: [python]
redirect_from:
  - /python/2012/06/23/genderator:-gender-from-first-name-with-python.html
---
I couldn't find a Python library that would give me a guess for gender based on first name that would handle international names as well, so I started an interface to [one written in C](http://www.heise.de/ct/ftp/07/17/182/).  That was taking too long (due to the added complexity around turning the C code into something suitable for a library), so I just wrote a parser for the data file in that project.  The code currently doesn't handle country selection (yet), but it should be suitable enough for most needs.  Here's some basic use:

{% highlight python %}
from genderator.detector import *
d = Detector()

d.getGender('Bob') == MALE # True

d.getGender('Sally') == FEMALE # True

d.getGender('Pauley') == ANDROGYNOUS # True
{% endhighlight %}

I18N is fully supported:

{% highlight python %}
d.getGender(u'\301lfr\372n') == FEMALE # True
{% endhighlight %}

The code can be found [on github](http://github.com/bmuller/genderator).
