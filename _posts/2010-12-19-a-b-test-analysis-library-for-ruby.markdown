---
redirect_to: https://bmuller.wtf
layout: post
title: A/B Test Analysis Library for Ruby
date: 2010-12-19 14:08
categories: [ruby, statistics, testing]
---
There are quite a few A/B testing libraries out there now for Rails and other frameworks.  Most of these, I've noticed, do not provide any sort of analysis component for validating differences in the results.  While most people are simply content to "eyeball" results, this process can be subjective and provide misleading interpretations.  

For instance, let's say you start an email campaign and have two subject lines you wish to test.  You pick some number of receipients for each test, and 300 people in Group A end up receiving one subject line and 335 in Group B receive the other.  You then wait a few days and look at the results, which are in the table below.

<div class="table">
<table>
<tr>
  <td></td>
  <td>Group A</td>
  <td>Group B</td>
</tr>
<tr>
  <td>Opened</td>
  <td>100</td>
  <td>135</td>
</tr>
<tr>
  <td>Not Opened</td>
  <td>200</td>
  <td>200</td>
</tr>
<tr>
  <td>Open / Not</td>
  <td>0.5</td>
  <td>0.675</td>
</tr>
</table>
</div>

If you simply "eyeball" the results, you might conclude based on a comparison of the ratios that Group B performed almost 20% better than Group A.  Here's where the problem lies; the apparent difference isn't an actual one (at least in a statistically significant sense).  It turns out that there is not a statistical difference between the two results (based on either a [G-Test][gtest] or a [Pearson's chi-square test][cstest] - you can verify the lack of statistical difference online [here](http://www.graphpad.com/quickcalcs/contingency1.cfm)).  In that case, the change should be actually just be abandoned or more tests run.

Misinterpretation is unfortunately an easy result of the common A/B split testing design.  When results can be easily misread and the resulting effort to implement changes wasted, it is important to determine with exactness whether or not a change will really matter.  With so many existing libraries that already make the actual testing part easy, I decided to create a Ruby library to handle simply analyzing the results in as simple a manner as possible.  The result, called [abanalyzer][abanalyzer], provides a dirt-simple method for determining whether or not there is a statistically significant difference within categorical data (A/B testing).

To install the gem:
{% highlight bash %}
gem install abanalyzer
{% endhighlight %}

Usage is as simple as possible.  Here is an example ruby script using the numbers above for the test:
{% highlight ruby %}
require 'rubygems'
require 'abanalyzer'

groups = {}
groups[:groupa] = { :opened => 100, :notopened => 200 }
groups[:groupb] = { :opened => 135, :notopened => 200 }

tester = ABAnalyzer::ABTest.new groups
# following will output "Not different."
puts (tester.different?) ? "Different!" : "Not different."

# to see the actual p-value, which is 0.07 (higher than 0.05 level of significance)
puts tester.gtest_p
{% endhighlight %}

[abanalyzer][abanalyzer] can handle testing multiple categories (i.e., A/B/C testing) and provides an interface to use both [G-Tests][gtest] and [Chi-square tests for independence][cstest].

The library itself is pretty simple; my hope is that it will be used to introduce some statistical rigour to what seems to currently be mostly guesswork and conjecture.  I'd hate to see wasted effort devoted to implementing changes that will not produce any actual differences in opens/clicks/views/etc.

[gtest]: http://en.wikipedia.org/wiki/G-test
[cstest]: http://en.wikipedia.org/wiki/Pearson%27s_chi-square_test
[abanalyzer]: https://github.com/livingsocial/abanalyzer