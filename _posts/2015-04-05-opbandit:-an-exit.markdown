---
layout: post
title: "OpBandit: An Exit, and Retrospective Lessons"
date: 2015-04-05 00:43
categories: [opbandit, deep thoughts]
---
[Blaine](https://twitter.com/OjoGringo) and I started [OpBandit](https://opbandit.com) back in 2012 with the idea that there was a real need for better optimization tools for online publishers.  We quit our jobs, built a company, and eventually had the pleasure of working with some of the [top](http://nytimes.com) [publishers](http://washingtonpost.com) [in](http://www.russmedia.com) [the](http://slate.com) [world](http://foreignpolicy.com).  We built a product that helped customers across seven countries serve hundreds of millions of optimized page views per month (in four languages!).  We've worked out of some of the [best real estate in the publishing world](http://www.nytimes.com/timespace/) and had the pleasure of growing close to some other [fantastic](http://getwiser.com) [startups](http://seen.co) in the media space.  It has been, without a doubt, one of the most educational experiences of my life (like an incredibly expensive, montessori style MBA).

After two years, right as we were getting into the swing of our first round of external financing, we were approached by [Vox Media](http://www.voxmedia.com).  Vox is one of the fastest growing media companies out there, and we have been huge fans of their work for a while.  They were serious, we listened, and eventually we came to this:

<blockquote class="twitter-tweet" lang="en"><p>Vox buys datascience company OpBandit <a href="http://t.co/qH6R4NaipM">http://t.co/qH6R4NaipM</a></p>&mdash; Financial Times (@FT) <a href="https://twitter.com/FT/status/585071420805361664">April 6, 2015</a></blockquote><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Over the past two and a half years, we've learned countles lessons along the way.  Many of our assumptions and decisions turned out to be correct (from pure luck or the benevolence of the startup gods) - and some were way off.  Just so I never forget, here's a brief list of a few of them.

## 1. Don't Underestimate the Sales Role
Unfortunately, I think I've historically looked down on the business development / sales sides of companies.  It was easy to think something like:

<blockquote><p>
I'm doing crazy math and writing complex code, how hard could it be to talk to a few folk on the phone and send lots of email.  BD is just the group of people who sign agreements with other companies to provide a technically impossible, non-existent feature as if it already exists.  Sales is just persistent calling and emailing until you eventually annoy a potential customer into buying your product.
</p></blockquote>

I now know that I was full of shit.  It takes a very unique set of skills to maintain interest and close deals, and those are skills that cannot be undervalued if a company is to succeed.  In my opinion, technical and product proficiency is necessary - but not sufficient - for rapid scaling.  While I think founders make great salespeople, if I could do it all over again, I would want to have a BD person on the team on day one.

## 2. Enterprise Sales Sucks
This is a grab bag of sales lessons.

 1. Many times we would email a potential customer / partner / investor and not hear back for days, send a few follow ups over the coming weeks, and eventually give up.  Then, they'd respond out of the blue and mention they'd been working behind the scenes and had great news and we'd be working together on whatever.  **Non-response isn't the same as never going to respond.**
 1. No matter what email client you use, figure out how to create templates.  80% of the millions of emails I sent over the last 2 years fit into one of a handful of templates.  **Use email templates.**
 1. Maintain relationships.  Even if a sale / partnership doesn't work out, the people you talked to will probably end up somewhere else at some point and might be able to make a sale happen there instead.  **Keep in touch.**

## 3. Build for Scale
It felt incredibly silly spending tons of time ensuring that our system could handle 10 million hits / hour when there were no customers and no hits so far.  It takes some weird combination of hubris and faith to spend a weekend working on automating massive server deployments when you have a single tiny instance running on AWS's free tier.  It seems ridiculous, but I think there's an immense value to developing with an expectation of success.  We didn't have to rewrite a "prototype" to handle increasing loads - since all of the code from day one was designed as if massive growth were inevitable.  It definitely costs more up front (prototypes obviously take less time to develop) - but there's a way to at least design for growth without having the expectation of needing rewrites.  For instance, choose a DB that can scale with you as you grow, instead of "We'll use DB X since it's easiest now - until we get to big for it, and then rewrite everything to handle DB Y when we get to that point."

Automate all the things.  5 minutes a week restarting that service that always needs to be restarted is absolutely worth 30 minutes right now to automate that restart.

Log all of the things.  If you aren't logging/tracking it, you can't fix it.  Track system stats, app stats, user stats, and everything else in between.  Track response times, query times, and how many cups of coffee you drink per day.  Track it all.  Store the stats - storage is cheap.  Realizing just now that your response time has gone up 10x over the last month is expensive.

Alert on all bad things.  Automated alerts are best when they warn about bad things that will happen soon, rather than alerts that occur when it's too late.  For instance, set up an alert to go off when your SSL certificate expires in one week, not when it has already expired.  If you're getting too many alerts, then they're either things that should be fixed or your system is too sensitive.  If I get a text message from a monitoring service, it means only one thing - I need to take some action.  Useless alerts are like the boy that cried shitwolf.  [Never cry shitwolf.](https://www.youtube.com/watch?v=H3yQqWNv91o)

## 4. Time / Expected Return Tradeoff: Beware the Time Suck
There will always be more things on your TODO list than you will ever complete, so constant reassessment of prioritization is necessary.  Implicitly, it's some sort of ranking for all possible tasks \\(X\\) based on the probability of success \\(P(x_i = success)\\) times the utility value of the successful outcome \\(u(x_i)\\) divided by the commitment of time necessary \\(t(x_i)\\), or

\\[ \max_X \frac{P(x_i) u(x_i)}{t(x_i)} \\]

Since neither \\(P\\) nor \\(t\\) are known, this equation is almost meaningless.  Good luck.

That said - there was one time in particular when we vastly overestimated the expected value of a successful outcome \\(u(x_i)\\) and spent way too much time (weeks) working on a particular opportunity.  It was a failure and a massive time suck.  You won't know exactly what the payoff will be - but the earlier you can nail that down the more you can understand what's potentially worth your time.

## 5. Get Some Office Space
Get some [office space](http://wework.com) ASAP.  The bump in productivity is worth the expense.

## 6. Your Time Estimate is Too Low
I can't remember a single time any of our time estimates for anything weren't at least half of what they should have been (if not less).  This goes for everything from the big ones like time to close a round and time until the next sale to the little ones like time to features being completed and how long it takes checks to clear.

I don't remember ever saying, "Boy, that was fast."  Ever.

## 7. Find Others to Join Your _[Folie à Plusieurs](http://en.wikipedia.org/wiki/Folie_%C3%A0_deux)_
We really lucked out with our [first adviser](https://twitter.com/rajmalikdc).  He was there from day one with a strong belief in us and our mission (and I do mean day one, when I said things like "What's a one-pager?").  Find others (early!) who will share in your vision and provide constant encouragement, because at many points you will feel uncertain about whether what you have is actual vision or mad delusion.  It's incredibly encouraging to have an external voice reminding you of what you've accomplished so far and expressing an expectation for future success.  It's not just nice things, though; having someone who is also willing to give you a solid kick if you need to refocus is also helpful.  What's important is that you have that external moral support before there are any major proof points.

Later, once the vision starts turning into reality (and you have happy customers and proof points and actual success stories) it's easier to find people who can share the vision (and who can help with [the doubts you'll feel even after the successes](http://en.wikipedia.org/wiki/Impostor_syndrome)).  It's critical, however, to find those early (blind) believers - and find them as early as possible.

***Those are the big ones.  Let me know what I'm missing in the comments!***
