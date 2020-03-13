---
layout: post
title: "Showoff: Github Repo Lists on Pages"
date: 2012-10-22 11:36
categories: [ github, moonshinedevco ]
---
I was looking around for a decent way to embed github repository information in web pages but couldn't find anything.  All I wanted was the ability to show the same things that are listed for each repo on a user's homepage, but I wanted to be able to show repos from across accounts (I have code under a few different organizations).  I couldn't find anything, so I created a little Javascript library called [showoff](http://github.com/moonshinedevco/showoff).

It's pretty simple to showoff two repos, each under a different organization.  You just give a **div** you want to fill, and the usernames and repos you want to see.

{% highlight javascript %}
$(function() { 
  SHOWOFF.load('examplerepos', { 
      'bmuller': [ 'sexmachine' ], 
      'moonshinedevco': [ 'showoff' ] 
    }); 
});
{% endhighlight %}

This results in the following display:

<div id="examplerepos">
</div>

It's not as pretty as the one github shows, but they have their own [octicons](https://github.com/blog/1106-say-hello-to-octicons).  If you want to use it, check out the [showoff github repo](http://github.com/moonshinedevco/showoff) to play.

<script type="text/javascript">$(function() { SHOWOFF.load('examplerepos', { 'bmuller': [ 'sexmachine' ], 'moonshinedevco': [ 'showoff' ] }); });</script>

