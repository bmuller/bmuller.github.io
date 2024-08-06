---
redirect_to: https://bmuller.wtf
layout: post
title: "Bandit: An A/B Testing Alternative for Rails"
date: 2011-11-12 14:26
categories: [ rails, vanity, statistics, testing ]
redirect_from:
  - /rails/vanity/statistics/testing/2011/11/12/bandit:-a-b-testing-alternative-for-rails.html
---
In a typical A/B test, two alternatives are compared to see which produces the most "conversions" (that is, desired results).  For instance, if you have a website with a big "Sign Up" button that you want visitors to click, you may wish to choose different background colors.  Under typical A/B testing guildlines, you would pick a number (say, *N*) of users for a test and show half of them one color and half of them another color.  After users are shown the button, you record the number of clicks that result from viewing each color.  Once *N* users view one of the two alternatives, a statistical test (generally categorical, like a Chi-Square Test or a G-Test) is run to determine whether or not the number of clicks (aka, "conversions") for one color were higher than the number of clicks for the other color.  This test determines whether the difference you observed was likely due simply to chance or whether the difference you saw was more likely due to an actual difference in the rate of conversion.

This method of testing is popular, but is fraught with issues (practical and statistical).  The [bandit gem][bandit] provides an implementation of an alternative method of testing for Rails that solves many of these issues.

## Issues with A/B Testing
There are a number of issues with A/B testing (some of which have been described in more detail [here](http://untyped.com/untyping/2011/02/11/stop-ab-testing-and-make-out-like-a-bandit)):

1. You can't try anything too crazy without having to worry about half of your users not converting.  For instance, you may want to try a horrendous color for your "Buy Now" button but are too afraid about potentially harming sales if your users hate it.  In this case, the risk of a big change may outweigh the possible benefit if your users like it.
1. A/B testing provides a way of only testing two alternatives at once.  Pick two, wait, pick two more, wait - this is not the easiest workflow if you want to test 50 options.
1. With A/B Testing, you need to have a fixed sample size to make the test valid (otherwise, you run the risk of repeated significance testing errors, as described in more detail [here](http://www.evanmiller.org/how-not-to-run-an-ab-test.html)).
1. Due to the fixed sample size requirement, you may have to wait a while before you get any results from your test (especially if the expected improvement is marginal, in which case your sample size would need to be larger).  This problem can be compounded if you don't get much traffic.
1. Designers and developers generally don't want to (and shouldn't have to) understand statistical concepts like [power](http://en.wikipedia.org/wiki/Statistical_power), [p-values](http://en.wikipedia.org/wiki/P-value), or [confidence](http://en.wikipedia.org/wiki/Confidence_intervals) when creating and evaluating tests.
1. There are no good answers for what you should do when A performs just as well as B.  Was the sample size just too small (implying you should try again with a large sample)?  Go with A?  Go with B?  Does it matter?  The reality is it may matter - but you won't know.

## The Bandit Method
The ultimate goal of A/B testing is to increase conversions.  The problem can be described terms that differ greatly from the multitude of questions A/B testing brings (i.e., "Is A better than B?" followed by "Is B better than C?" followed by "Is C better than D?" _ad_ _infinitum_).  Instead, imagine you have a multitude of possible alternatives, and you want to make a decent choice between alternatives you know perform well and alternatives you haven't tried very often each time a user requests a page.  With each page load, pick the best alternative most of the time and an alternative that hasn't been displayed much some of the time.  After each display, monitor the conversions and update what you consider the "better" alternatives to be.  This is the basic method of a solution to what is called the multi-armed bandit problem.

With a bandit solution, there is no concept of a "test".  At no point does the system announce a winner and a loser.  Alternatives can be added or removed at any time.  The better performing alternatives will be displayed more often, and the worst alternatives will rarely be displayed.  At any point, if one of the poorly performing alternatives begins to perform better it will be shown more often.  This provides solutions to all of the problems listed above:

1. Go ahead and try something crazy.  If it performs poorly, it won't be shown very often.
1. Pick as many alternatives as you'd like and add them.
1. There's no "test", and no minimal sample size needed before optimization can start.
1. Information about conversions is utilized as users convert or do not convert.  There is no pause before results can be immediately used in selecting the next alternative to display to a visitor.
1. Designers and developers can add alternatives or remove them at any time.  The system will adjust immediately.  If an alternative seems to be consistently performing poorly, it can be removed at any time.  Alternatively, it can just be left forever.  The best option will always be displayed the most often.  There are no complicated decisions that have to be made up front or requirements that designers or developers know anything about proper statistical hypothesis testing.
1. If one alternative performs the same as another, they will both be displayed with the same regularity.  There would be no need to choose one over the other or remove either of them.

## Bandit Gem
While there are a few A/B testing libraries for Rails out there, the preeminant one ([Vanity](http://vanity.labnotes.org/)) has [statistical issues](/vanity/statistics/testing/2011/03/17/statistical-analysis-and-a-b-testing-correctly.html) and is [unreliable](https://github.com/assaf/vanity/issues/11) in a production environment.  [Bandit][bandit] was created to test the feasibility of a multi-armed bandit based alternative to A/B testing and to solve the issues with the Rails based A/B testing gems.  It is still in development, though - use at your own risk.

## Resources
* [bandit gem][bandit]
* [http://untyped.com/untyping/2011/02/11/stop-ab-testing-and-make-out-like-a-bandit](http://untyped.com/untyping/2011/02/11/stop-ab-testing-and-make-out-like-a-bandit)
* [http://en.wikipedia.org/wiki/Multi-armed_bandit](http://en.wikipedia.org/wiki/Multi-armed_bandit)
* [http://www.evanmiller.org/how-not-to-run-an-ab-test.html](http://www.evanmiller.org/how-not-to-run-an-ab-test.html)

[bandit]: https://github.com/bmuller/bandit