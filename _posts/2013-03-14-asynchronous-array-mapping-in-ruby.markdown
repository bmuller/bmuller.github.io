---
redirect_to: https://bmuller.wtf
layout: post
title: "Asynchronous Array Mapping in Ruby"
date: 2013-03-14 19:48
categories: [ruby, eventmachine]
---
[EventMachine](http://rubyeventmachine.com/) is great, but may require [a few fights](http://dev.af83.com/2011/09/20/fighting-with-eventmachine.html) to get started.

Recently, I wanted to be able to get the sizes of each image in an array using [FastImage](https://github.com/sdsykes/fastimage).  It's fast, but it's not that fast when you've got tens or hundreds of images you're trying to size at once.

What I needed was an asynchronous map method for Arrays, like this:

{% highlight ruby %}
images = [ "http://example.com/one.png", "http://example.com/two.png", ... ]
images.async_map { |img| FastImage.size(img) }
{% endhighlight %}

EventMachine did not make this easy.  After some fighting, here's what I came up with:

{% highlight ruby %}
class Array
  def async_map(&block)
    results = nil
    EventMachine.run do
      operation = proc { |item, iter|
        EventMachine.defer(proc { block.call(item) }, proc { |r| iter.return(r) })
      }
      callback = proc { |rs|
        results = rs
        EventMachine.stop
      }
      EventMachine::Iterator.new(self, length).map(operation, callback)
    end
    results
  end
end
{% endhighlight %}

It works (10x speed increase!), but I'd like to believe that there's got to be an easier way to do this.