---
layout: post
title: "Stopping Time During Python Tests"
date: 2012-02-12 20:50
categories: [python, testing]
---
When running unit tests in Python, it's often the case that I need to "stop time" so that the current time remains the same during the entire execution of the test.  For instance, in cases where I expect the result of a slow (networked) operation to return a value based on a creation time.  If this creation process crosses into a new second, then the creation time of each of the objects will not be the same.  This becomes a problem when there is latency associated either with the request to create the object or in the response after the object has been created (causing a potentially large difference between a the time the request was made and the time of the response).  To compensate, I use a decorator for the unit test methods that need it.

Here's the decorator function:

{% highlight python %}
import time

def stopTime(f):
    original = time.time
    def newf(*args, **kwargs):
        now = original()
	time.time = lambda: now
        result = f(*args, **kwargs)
	time.time = original
	return result
    return newf
{% endhighlight %}

Here's an example of usage in a unit test:

{% highlight python %}
import unittest, time

class TestSomething(unittest.TestCase):

    @stopTime
    def test_something(self):
        a = time.time()
        time.sleep(3)
	b = time.time()
        self.assertEqual(a, b)
{% endhighlight %}

In this case, <code>a</code> and <code>b</code> will be the same, thus demonstrating your awesome ability to alter the [space-time continuum](http://en.wikipedia.org/wiki/Spacetime).

To further illustrate what's occurring, here's a picture of what you're doing:

<a href="http://en.wikipedia.org/wiki/File:Spacetime_curvature.png">
<img src="http://upload.wikimedia.org/wikipedia/commons/2/22/Spacetime_curvature.png" />
</a>