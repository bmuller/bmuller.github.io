---
layout: post
title: "Sample Size Calculations in Ruby"
date: 2012-08-17 16:47
categories: [statistics, ruby]
---
I really love the [abba tool](http://www.thumbtack.com/labs/abba/).  It's great.  So is R.  So are [Zed Shaw's rants on statistics](http://zedshaw.com/essays/programmer_stats.html).

What really sucks is the complete lack of basic statis libraries in Ruby.  After spending more time than I'd like to admit going over some reference implementations in R, I added both sample size and confidence interval calculations to [ABAnalyzer](https://github.com/livingsocial/abanalyzer).  Here are some excerpts from the docs.


## Sample Size Calculations
Let's say you want to determine how large your sample size needs to be for an A/B test.  Let's say your baseline is 10%, and you want to be able to determine if there's at least a 10% relative lift (1% absolute) to 11%.  Let's assume you want a [power](http://en.wikipedia.org/wiki/Statistical_power) of 0.8 and a [significance level](http://en.wikipedia.org/wiki/Statistical_significance) of 0.05 (that is, an 80% chance of that you'll fail to recognize a difference when there is one, and a 5% chance of a false negative).

{% highlight ruby %}
require 'rubygems'
require 'abanalyzer'

ABAnalyzer.calculate_size(0.1, 0.11, 0.05, 0.8)
 => 14751
{% endhighlight %}

This means that you will need at least 14,751 people in each group sample.  You can see this same example with R at [on the 37 signals blog](http://37signals.com/svn/posts/3004-ab-testing-tech-note-determining-sample-size).


## Confidence Intervals
You can also get a [confidence interval](http://en.wikipedia.org/wiki/Confidence_interval).  Let's say you have the results of a test where there were 711 successes out of 4000 trials.  To get a 95% confidence interval of the "true" value of the conversion rate, use:

{% highlight ruby %}
ABAnalyzer.confidence_interval(711, 4000, 0.95)
 => [0.1659025512617185, 0.1895974487382815]
{% endhighlight %}

This means (roughly) that if you ran this experiment over and over, 95% of the time the resulting proportion would be between 17% and 19%.

You can also determine what the relative confidence intervals would be.  Let's say that your old conversion rate was 13%, and you wanted to know what sort of relative lift you could get.

{% highlight ruby %}
ABAnalyzer.relative_confidence_interval(711, 4000, 0.13, 0.95)
 => [0.27617347124398833, 0.45844191337139606]
{% endhighlight %}

This means (roughly) that if you ran this experiment over and over, 95% of the time the resulting proportion would be a relative lift of between 28% and 46%.  Go buy yourself a beer!
