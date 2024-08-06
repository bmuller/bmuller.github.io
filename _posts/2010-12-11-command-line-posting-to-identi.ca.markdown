---
redirect_to: https://bmuller.wtf
layout: post
title: Command Line Posting to Identi.ca
categories: [identi.ca]
date: 2010-12-11 14:31
---
I looked around for a simple command line program to post to [identi.ca](http://identi.ca) but I couldn't find one that:
 1. worked
 1. auto-shortened URL's
 1. was executable and not a giant overkill library

Naturally, I then threw something simple together in Python (script below).  The script will auto-shorten URL's (using [ur.ly](http://ur.ly), which seemed to have the simplest API) and doesn't require quoting your post.  After putting your username/password at the top of the file:

{% highlight bash %}
$> ./status This is an example post with a url in it http://google.com
Posted: This is an example post with a url in it http://ur.ly/Q
{% endhighlight %}

## The Code
<script src="https://gist.github.com/737651.js"> 
</script>




