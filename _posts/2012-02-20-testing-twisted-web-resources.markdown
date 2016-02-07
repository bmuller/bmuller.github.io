---
layout: post
title: "Testing Twisted Web Resources"
date: 2012-02-20 21:33
categories: [python, twisted]
---
Testing web resources in [Twisted](http://twistedmatrix.com) can be a bit of a pain, and the Twisted docs don't describe how best go go about writing tests for [twisted.web.resource.Resource](http://twistedmatrix.com/documents/8.1.0/api/twisted.web.resource.Resource.html) objects.  

Generally, usage of <code>twisted.web</code> resources looks something like this:

{% highlight python %}
from twisted.internet.defer import inlineCallbacks
from twisted.internet import defer, reactor
from twisted.web import resource
from twisted.web.server import NOT_DONE_YET

class ChildPage(resource.Resource):
    def render(self, request):
        d = defer.Deferred()
        d.addCallback(self.renderResult, request)
        reactor.callLater(1, d.callback, "hello")
        return NOT_DONE_YET

    def renderResult(self, result, request):
        request.write(result)
        request.finish()
        
class MainPage(resource.Resource):
    def __init__(self):
        resource.Resource.__init__(self)
        self.putChild('childpage', ChildPage())
{% endhighlight %}

I created a small bit of code that wraps some of the testing library in Twisted.  This code can be used to easily create tests by just using a <code>DummySite</code> instead of a <code>twisted.web.server.Site</code>.  You can then call <code>get</code> and <code>post</code> on that site (and pass optional dictionaries of get/post arguments and headers).  Here's what a test looks like:

{% highlight python %}
from twisted.trial import unittest
from twisted_web_test_utils import DummySite

class WebTest(unittest.TestCase):
    def setUp(self):
        self.web = DummySite(MainPage())

    @inlineCallbacks
    def test_get(self):
        response = yield self.web.get("childpage")
        self.assertEqual(response.value(), "hello")

	# if you have params / headers:
	response = yield self.web.get("childpage", {'paramone': 'value'}, {'referer': "http://somesite.com"})
{% endhighlight %}

Here's the testing code if you want to use it:

<script src="https://gist.github.com/1873035.js?file=twisted_web_test_utils.py">
</script>

And with that, a few hours worth of work will save me at least a few 10 minute segments in the future.