---
redirect_to: https://bmuller.wtf
layout: post
title: Javascript Implementation of Jenkins' Hash
date: 2010-12-28 21:02
categories: [javascript, hashing, memcache]
---
[Libmemcached](http://libmemcached.org/libMemcached.html) can use a cluster of servers as a backend.  Each key is stored/read on only one server.  The client determines which server to store/read each key based on a hash of the key.  The hash value is a 32-bit integer whose modulus with the number of servers results in an integer in the range (0, number of servers).  This is a pretty simple, but thoroughly useful, way to (roughly and likely mostly) evenly bucketize strings.

My needs required getting the same hash value in Javascript for a [node.js](http://nodejs.org) project I'm working on.  There were a few questionable attempts at some of the [Jenkins hash functions](http://en.wikipedia.org/wiki/Jenkins_hash_function), but all looked somewhat dubious.  I decided to implement the simplest, the ["one-at-a-time"](http://www.burtleburtle.net/bob/hash/doobs.html) hash function, which seemed to be sufficient for my hashing needs (and which is the default hash function in libmemcached).

So here's the function.  It accepts a string key and the interval size to use as a modulus for the integer hash value.

{% highlight javascript %}
function jenkins_hash(key, interval_size) {
   var hash = 0;
   for (var i=0; i<key.length; ++i) {
      hash += key.charCodeAt(i);
      hash += (hash << 10);
      hash ^= (hash >> 6);
   }
   hash += (hash << 3);
   hash ^= (hash >> 11);
   hash += (hash << 15);
   // make unsigned and modulo interval_size
   return (hash >>> 0) % interval_size;
}
{% endhighlight %}