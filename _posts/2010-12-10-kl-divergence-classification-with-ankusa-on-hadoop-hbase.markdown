---
layout: post
title: KL Divergence Classification with Ankusa on Hadoop/HBase
categories: [ankusa, hadoop, hbase]
---
I [recently posted](/2010/12/02/naive-bayes-classification-in-ruby-using-hadoop-and-hbase.html) a description of a new text classification project called [ankusa](https://github.com/livingsocial/ankusa).  I decided to add a new classification method in addition to the [naive bayes classifier](http://en.wikipedia.org/wiki/Naive_Bayes_classifier) to provide an alternative method of differentiation.  I've used it before for determining [semantic distance](http://en.wikipedia.org/wiki/Semantic_similarity) between different categories of text and thought it could be useful here, especially under the right conditions.

The method uses [Kullback-Liebler divergence](http://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence) to measure the difference between the probability distributions of each class of text and the text to classify.  It is not a true distance measure in that it does not satisfy the triangle inequality, but it can still be quite useful for applications like text classification.  It can be slightly faster (than naive Bayes) in cases where you have a large corpora because it doesn't have to calculate prior probabilities (only likelihoods).  The implementation uses [Laplacian smoothing](http://en.wikipedia.org/wiki/Laplacian_smoothing) just like the Bayes classifier.

The one caviat, however, to its use is that without a large enough test string (i.e., the text you are trying to classify) your results may not be as accurate as they could be with the naive Bayes classifier.

KL divergence classifier usage:
{% highlight ruby %}
require 'rubygems'
require 'ankusa'

# connect to HBase 
storage = Ankusa::HBaseStorage.new 'localhost'
# or use in-memory storage
storage = Ankusa::MemoryStorage.new

c = Ankusa::KLDivergenceClassifier.new storage

# Each of these calls will return a bag-of-words
# has with stemmed words as keys and counts as values
c.train :spam, "This is some spammy text"
c.train :good, "This is not the bad stuff"

# This will return the most likely class (as symbol)
puts c.classify "This is some spammy text"
# returns :spam

# This will return Hash with classes as keys and 
# distances >= 0 as values
p c.distances "This is some spammy text"
# returns {:good=>0.693147180559945, :spam=>0.0}

# get a list of all classes
puts c.classnames

# close connection
storage.close
{% endhighlight %}

