---
redirect_to: https://bmuller.wtf
layout: post
title: "Free, Automatic Twisted Error Reporting"
date: 2012-04-30 17:08
categories: [python, twisted, error reporting, airbrake]
---
When you have a [Twisted](http://twistedmatrix.com) server running somewhere in the cloud, there really aren't that many options for automatic notifications when there's an error.  If you're using Rails, then there are a number of options to do this sort of thing
([New Relic](http://newrelic.com), [Airbrake](http://www.airbrake.io), etc).  Many of these will work for [WSGI](http://wsgi.org) applications, but there isn't much in the way of automatic error reporting for Python otherwise.

I've gotten used to using [Airbrake](http://www.airbrake.io) with Rails, so I wanted to figure out how to integrate a Python application with it.  It turns out, there's been at least [one attempt](https://github.com/pulseenergy/airbrakepy), but it's synchronous (which could potentially stall a Twisted application if it can't make a connection to the Airbrake server).

Enter [txairbrake](https://github.com/bmuller/txairbrake).  It's written specifically for Twisted applications and is non-blocking (using <code>twisted.web.client.getPage</code>).  It's also dead simple to use:

{% highlight python %}
# import the observer
from txairbrake.observers import AirbrakeLogObserver

# Create observer.  Params are api key, environment, and use SSL.  The last two are optional.
ab = AirbrakeLogObserver("mykey", "production", True)

# start observing errors
ab.start()
{% endhighlight %}

Any uncaught exceptions will then be reported to the Airbrake server, where you can set up email notifications.

Additionally, if you're tight on cash and don't want to shell out tons of money to Airbrake, consider setting up [Errbit](https://github.com/errbit/errbit) instead.  It's free, Airbrake API compliant, and you can run it for free on Heroku.  If you go this route,
just pass a new constructor argument of <code>airbrakeHost</code> to the <code>AirbrakeLogObserver</code> with the location of your Errbit server.

There, now you have free, automatic error reporting from within a Twisted application.