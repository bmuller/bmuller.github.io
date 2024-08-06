---
redirect_to: https://bmuller.wtf
layout: post
title: "Sending Email with Python Twisted"
date: 2011-01-22 13:21
categories: [python, twisted]
---
[Twisted](http://twistedmatrix.com) is an great asynchronous networking library for Python.  I was looking for an example of using it to send mail locally, but most examples assume you have access to an SMTP server that you can send through.  After some trial and error, I figured out a method that seems to work based on connecting directly to each recipient's mail host.

The following is an example that does not assume that you have access to an SMTP server.  It first resolves the DNS MX record for the recipient's domain and then attempts to connect to it to send the message:

{% highlight python %}
from twisted.internet import defer
from twisted.mail import smtp, relaymanager
from twisted.internet import reactor
from cStringIO import StringIO

MXCALCULATOR = relaymanager.MXCalculator()
def getMailExchange(host):
    def cbMX(mxRecord):
        return str(mxRecord.name)
    return MXCALCULATOR.getMX(host).addCallback(cbMX)

def sendEmail(mailFrom, mailTo, msg, subject=""):
    def dosend(host):
        print "emailing %s (using host %s) from %s" % (mailTo, host, mailFrom)
	mstring = "From: %s\nTo: %s\nSubject: %s\n\n%s\n"
	msgfile = StringIO(mstring % (mailFrom, mailTo, subject, msg))
	d = defer.Deferred()
        factory = smtp.ESMTPSenderFactory(None, None, mailFrom, mailTo, msgfile, d,
                                          requireAuthentication=False, 	
					  requireTransportSecurity=False)
        reactor.connectTCP(host, 25, factory)
        return d
    return getMailExchange(mailTo.split("@")[1]).addCallback(dosend)


d = sendEmail('YOU@localhost', 'TO ADDY', 'this is a message', 'this is a test subject')
d.addCallback(lambda _: reactor.stop())

reactor.run()
{% endhighlight %}

You could use this code to send a crap ton of emails all asynchronously.  Fun stuff.