---
layout: post
title: "Memcache Memoizing in Ruby"
date: 2011-01-26 15:48
categories: [ruby, memcache]
---
I realized recently with some amount of astonishment that the [ruby memcache gem](https://rubygems.org/gems/memcache) does not have the ability to [memoize](http://en.wikipedia.org/wiki/Memoization) values.  In the general case of memoization, it can be suffienct to simply "remember" values by setting some sort of static class variable.  In the case, however, where you have multiple machines which may all need to calculate the same value, it is better to have a single location for the collective memory so that if one machine has recently calcuated it all of the other machines can use the result of that calcuation.  Enter [memcached](http://memcached.org/).  

I've written some very simple code to provide memoization within the **MemCache** client class.  There are two additional methods - one which allows simple memoization and the other allows you to wrap the key and age for the value into a Proc that can then be called.  Here's the code:
{% highlight ruby %}
require 'memcache'

class MemCache
  def memoize(key, age=0)
    value = get(key)
    if value.nil? and block_given?
      value = yield
      add(key, value, age)
    end
    value
  end

  def memoize_proc(key, age=0, &block)
    Proc.new { memoize key, age, &block }
  end
end
{% endhighlight %}
Then, if there's some expensive code that is run quite a bit within a method, you can easily memoize the result:
{% highlight ruby %}
m = MemCache.new 'localhost'

class Record
  def self.lookup(id)
    m.memoize(id, 10) { 
      # perform intensive lookup here - as example, return some dummy data
      { :name => 'value', :age => '20' }
    }
  end
end
{% endhighlight %}

If you need to fetch the result frequently and don't want to keep calling the memoize method with the key name and age, you can
have your code wrapped in a Proc:
{% highlight ruby %}

m = MemCache.new 'localhost'
f = m.memoize_proc('key', 10) {
  # this is your computationally intensive part
  "something hard to compute"
}

puts f.call  # calls codeblock, stores result in memcache
puts f.call  # gets result from memcache
{% endhighlight %}

There are probably other examples of this out there - but since I was doing it anyway I thought I'd put it up on the tubes.