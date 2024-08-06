---
redirect_to: https://bmuller.wtf
layout: post
title: "txque: (Real) Async Background Jobs for Python"
date: 2015-03-21 12:40
categories: [python, twisted, txque]
redirect_from:
  - /python/twisted/txque/2015/03/21/txque:-async-background-jobs-for-python.html
---
There are a number of Python projects I'm working on (many of them utilizing [Twisted](http://twistedmatrix.com)) that all would benefit from the ability to enqueue background jobs for workers to chew on.  While there are a number of existing background job options for Python ([Gearman](http://gearman.org/), [RQ](http://python-rq.org/), and [Celery](http://www.celeryproject.org/) to name a few), I wanted the ability to seamlessly utilize the batteries of [Twisted](http://twistedmatrix.com).  Most importantly, I don't want a worker tied up if a job involves a lot of IO.  I want the ability to dispatch jobs asynchronously to multiple machines each running some number of multi-threaded workers that can all handle asynchronous IO.

Since Twisted already handles thread pooling, there really wasn't that much left to do except create some wrappers for the concepts of jobs, workers, and dispatchers (things that enqueue jobs).  The result is named [txque](https://github.com/bmuller/txque) - and is dead simple to use.

Here's the definition of a job:

{% highlight python %}
from txque.work import Job

class MyBackgroundJob(Job):
    def run(self, anArgument, akeyword=avalue):
        # Now do some work.  This work can be synchronous, or it can return a deferred.
	someExpensiveFunction(anArgument, akeyword)
{% endhighlight %}

Here's what it looks like to enqueue a job:

{% highlight python %}
from txque.dispatchers.sql import MySQLDispatcher

# create a dispatcher
dispatcher = MySQLDispatcher(user="username", passwd="password", db="txque")

# queue the job, then stop the reactor once queued
dispatcher.queue(MyBackgroundJob('hi there'), queue='default', priority=10)
{% endhighlight %}

And then you can run as many workers as you'd like:

{% highlight bash %}
twistd -noy worker.tac
{% endhighlight %}

Check it out at [https://github.com/bmuller/txque](https://github.com/bmuller/txque).
