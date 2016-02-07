---
layout: post
title: "Statistical Analysis and A/B Testing (Correctly)"
date: 2011-03-17 16:01
categories: [vanity, statistics, testing]
---
We've been playing with [Vanity](http://vanity.labnotes.org) recently at [LivingSocial](http://livingsocial.com) and have found it to be generally useful.  During a recent test, however, we saw the option listed as the "best choice" change with almost every dashboard page load.  This should not generally be happening if the test for significance is implemented correctly.  The first thing we did was add some numbers to the dashboard showing total views for each option and the number of track events for our conversion metric.  That's when I noticed a problem: what Vanity was claiming as a significant difference (at a 95% confidence level) wasn't actually significant (based on a [G-test]).  After some digging in the [source](https://github.com/assaf/vanity), I found the following issues.

## Issue One: Wrong Number of Tails 
The first two issue relates to the way in which the two-proportion [Z-test] is implemented.  Vanity links to [this instructional post](http://20bits.com/articles/statistical-analysis-and-ab-testing/) on [their result interpretation page](http://vanity.labnotes.org/ab_testing.html#interpret), and I assume it was used as the basis for Vanity's implementation.  While I think there are a few things wrong with the post (see the next issue), I believe one of the biggest issues in Vanity is the impropper use of a [one-tailed test](http://en.wikipedia.org/wiki/Two-tailed_test).  The instructional post on stats and ab-testing describes the correct use of the one-tailed test in the case where you have identified a "control" (presumably the original page) and a "experiment" page and want to only test whether the new page performs better than the old one.  One-tailed tests are used in this sort of case, when one wants to know if a statistic from one defined group is greater than another defined group (say, case over control proportion).  

Vanity, however, picks the second best performing group and then uses it as the "control" group in a one-tailed test to see whether the best group's proportion is greater than the second best.  This "control" group may be a different group on each dashboard page load.  The result is a test to see whether the proportions are equal or not equal, as opposed to a test to see whether or not one specific proportion is greater than another specific proportion.  Essentially, a one-tailed test is being used for a two-tailed hypothesis.  

Why does this matter?  Well, in our case, it mattered quite a bit.  Vanity was calling a difference significant when it shouldn't have been.  The counts are in the following table.

<table>
  <tr class="thead">
    <td>Group</td>
    <td>Viewed</td>
    <td>Converted</td>
  </tr>
  <tr>
    <td>A</td><td>409199</td><td>22399</td>
  </tr>
  <tr>
    <td>B</td><td>409351</td><td>22779</td>
  </tr>
</table>

Vanity's conclusion was:

    With 95% probability this result is statistically significant.

For a one-tailed test, this conclusion is correct.  For a two-tailed test, however, the confidence level is only 92.5% and is not significant.  To see how far off the result is, the results of my [G-test] produced a [p-value] of 0.0721, which is not significant.  Based on Vanity's conclusion, though, we might have assumed a difference and then put in effort into making changes that would not have actually mattered.

Ultimately, what you generally want to know in A/B testing isn't just want the post Vanity links to claims, i.e., "does A perform better than B."  What you actually want to know is "Does A perform better **or worse** than B".  These questions might seem equivalent, but they have very different implications in terms of choosing a statistical hypotheses and resulting test.  The one-tailed test chosen by Vanity is only applicable when you want to specifically test whether or not some well-defined A performs better than a well-defined B.  Not only is that not what an A/B tester probably wants to know (rather, they want to know "better or worse"), but the test itself is implemented incorrectly because the A vs B groups can flip back and forth depending on which is currently performing better at the time the dashboard is loaded.

These combined problems result in false positives in terms of identifying significant differences between proportions and can lead to wasted development time in terms of making unnecessary changes.  Additionally, because the rate of false positives is high due to the incorrect implementation of a one-tailed test, Vanity will vacillate between calling an option significantly different and not.

## Issue Two: Wrong Test Application
The second issue is related to the [Z-test] itself.  The implementation used in Vanity does not pool the sample proportion, which is necessary to produce the best estimate for sample variance.  I'll leave out an explanation as to why pooling the proportion produces a more accurate result (it's rather involved), but I will say that it is trivial to modify existing code to use a pooled method.  For those interested in learning more about the reasoning behind pooling proportions, more information can be found [here](http://apcentral.collegeboard.com/apc/members/courses/teachers_corner/49013.html).

## Fix
To fix the above issues, I'm going to [fork Vanity](https://github.com/livingsocial/vanity) and switch to a completely different test.  Since the result of an A/B test is categorical data, it's perfect for a [Pearson's chi-square test of independence](http://en.wikipedia.org/wiki/Pearson%27s_chi-square_test#Test_of_independence) or better yet a [G-test].  Such a test will show the amount of difference, if any, between any number of testing variations.  In addition, we will be adding more information about the extent of the difference, with a recommendation noting whether or not a user should continue running a test.

Our modifications will be available on [github](https://github.com/livingsocial/vanity).

[Z-test]: http://en.wikipedia.org/wiki/Z-test
[G-test]: http://en.wikipedia.org/wiki/G-test
[p-value]: http://en.wikipedia.org/wiki/P-value