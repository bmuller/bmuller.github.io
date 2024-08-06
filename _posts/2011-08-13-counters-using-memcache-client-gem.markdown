---
redirect_to: https://bmuller.wtf
layout: post
title: "Incr/Decr Counters Using memcache-client"
date: 2011-08-13 20:59
categories: [memcache, ruby]
---
Based on some recent changes in the [memcached](http://memcached.org/) library, the [incr](http://seattlerb.rubyforge.org/memcache-client/classes/MemCache.html#M000009) method in the 
[memcache-client](http://seattlerb.rubyforge.org/memcache-client/) gem no longer works as expected.  For instance, the following:

{% highlight ruby %}
require 'rubygems'
require 'memcache-client'

m = MemCache.new 'localhost'
m.set('counter', 0)
m.incr('counter')
{% endhighlight %}

will result in the following error:

<pre>
MemCache::MemCacheError: cannot increment or decrement non-numeric value
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:926:in `raise_on_error_response!'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:831:in `cache_incr'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:865:in `call'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:865:in `with_socket_management'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:827:in `cache_incr'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:342:in `incr'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:886:in `with_server'
			 from /usr/lib/ruby/gems/1.8/gems/memcache-client-1.8.5/lib/memcache.rb:341:in `incr'
			 from (irb):5
			 from /usr/local/lib/site_ruby/1.8/rubygems.rb:123
</pre>

This is caused by the memcache-client gem [marshalling](http://ruby-doc.org/core/classes/Marshal.html) everything before it's stored in memcache.  Memcache needs the actual, unmarshalled, integer value to be stored.  The code above should be changed to:

{% highlight ruby %}
require 'rubygems'
require 'memcache-client'

m = MemCache.new 'localhost'

# set the raw value initially by passing in a fourth argument of true
m.set('counter', 0, 0, true)

# increment the raw integer value
m.incr('counter')

# you can now decrement the raw integer value as well
m.decr('counter')
{% endhighlight %}

The fix is simple, but not noted anywhere (I can find it) in the [memcache-client](http://seattlerb.rubyforge.org/memcache-client/) documentation.  Besides a few  mentions on Google-groups <i>sans</i> solution, I couldn't find any references to this issue elsewhere on the world wide intertubes.  I find the atomic incr/decr functionality in memcache to be quite useful; I hope this can help alleviate any issues others might be having with this problem.
