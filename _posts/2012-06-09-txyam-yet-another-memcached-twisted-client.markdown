---
redirect_to: https://bmuller.wtf
layout: post
title: "txyam: Yet Another Memcached Twisted Client"
date: 2012-06-09 12:51
categories: [twisted, python, memcache]
redirect_from:
  - /twisted/python/memcache/2012/06/09/txyam:-yet-another-memcached-twisted-client.html
---
There are a number of number of [memcached](http://memcached.org) client libraries written for [Python Twisted](http://twistedmatrix.com) (like [twisted-memcached](https://github.com/dustin/twisted-memcached), [txconnpool](https://github.com/ericflo/txconnpool), etc).  None of them did everything I wanted, though.  Here's what I needed:

 1. A reconnecting client: if a connection is closed the client should keep trying to reconnect
 1. Partitioning: You should be able to use as many memached servers as you'd like and partition the keys between them
 1. Pickling/Compression: You should be able to effortlessly store objects (and have them compressed if you'd like)

Naturally, I went ahead and wrote a new client that does all of this.  I'm calling it [txyam](http://github.com/bmuller/txyam), as in "Yet Another Memcached" client.  Here's some example usage:

{% highlight python %}
# import the client
from txyam.client import YamClient

# create a new client - hosts are either hostnames (default port of 11211 will be used) or host/port tuples
hosts = [ 'localhost', 'otherhost', ('someotherhost', 123) ]
client = YamClient(hosts)

# Run some commands.  You can use all of the typical get/add/replace/etc
# listed at http://twistedmatrix.com/documents/current/api/twisted.protocols.memcache.MemCacheProtocol.html
client.set('akey', 'avalue').addCallback(someHandler)

# Additionally, you can set / add / get picked objects
client.addPickled('anotherkey', { 'dkey': [1, 2, 3] }, compress=True)
client.getPickled('anotherkey', uncompress=True)

# get stats for all servers
def printStats(stats):
    for host, statlist in stats.items():
        print host, statslist['bytes']
    client.stats().addCallback(printStats)
{% endhighlight %}
