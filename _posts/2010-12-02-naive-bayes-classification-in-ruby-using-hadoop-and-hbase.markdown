---
redirect_to: https://bmuller.wtf
layout: post
title: Naive Bayes Classification in Ruby using Hadoop and HBase
categories: [ankusa, hbase, hadoop, ruby]
---
One of the problems I've run into recently at work is that we have quite a bit of text that needs to be classified.  My first thought was to use one of  the simplest classification methods, a [naive bayes classifier](http://en.wikipedia.org/wiki/Naive_Bayes_classifier).  I couldn't find anything that could possibly handle many terabytes of  data, though.  Most Ruby implementations, like [the classifier gem](https://github.com/cardmagic/classifier), have only a simplistic implementation (for instance, the classifier gem doesn't actually provide a true naive bayes implementation in that it ignores [prior probabilities](http://en.wikipedia.org/wiki/Prior_probability)).  I decided to create a better naive bayes implementation (for instance, using a [Laplacian smoother](http://en.wikipedia.org/wiki/Laplacian_smoothing)) that could also handle up to many terabytes of corpus data.

We already have a [Hadoop](http://hadoop.apache.org) cluster with [HBase](http://hbase.apache.org/) running, and HBase is perfect for storing data like
word counts.  The [HBaseRb](https://github.com/bmuller/hbaserb) gem provides an easy interface for Ruby to interact with HBase.  

I spent today implementing the classifier, and have released the code in the [ankusa](https://github.com/livingsocial/ankusa) gem.  Unlike other 
classifiers written in Ruby, ankusa has a fairly abstract storage class that can easily be implemented for other storage solutions.  For instance,
the two that come with the gem provide both HBase storage and in memory storage.

To use the gem:
{% highlight bash %}
gem install ankusa
{% endhighlight %}

Then:
{% highlight ruby %}
require 'rubygems'
require 'ankusa'

# connect to HBase 
storage = Ankusa::HBaseStorage.new 'localhost', 9090
# or use in-memory storage
storage = Ankusa::MemoryStorage.new

c = Ankusa::Classifier.new storage

c.train :spam, "This is some spammy text"
c.train :good, "This is not the bad stuff"

# This will return the most likely class (as symbol)
puts c.classify "This is some spammy text"

# This will return Hash with classes as keys and 
# membership probability as values
puts c.classifications "This is some spammy text"

# get a list of all classes
puts c.classes

# close connection
storage.close
{% endhighlight %}

The classifier does return probabilities (when you use the *classifications* method, unlike the classifier gem which only returns
log likelihoods).  Additionally, the classifier has no limitations on the size of the corpora (HBase can handle petabytes of data
depending on your cluster size), so realistically your training set can be as large as you need it to be.