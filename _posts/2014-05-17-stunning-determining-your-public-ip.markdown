---
redirect_to: https://bmuller.wtf/blog/2014-05-17-stunning-determining-your-public-ip
layout: post
title: "Stunning: Determining Your Public IP"
date: 2014-05-17 14:14
categories: [internet, ruby]
redirect_from:
  - /internet/ruby/2014/05/17/stunning:-determining-your-public-ip.html
---
Programmatically fetching your public IP address (aka, internet visible IP) can be tough.  Most often, I've done something silly like fetching [whatismyip.com](http://whatismyip.com) and then parsing the page.  That introduces a pretty bad dependency.

Fortunately, there's actually a protocol for asking for your internet visible IP called [Session Traversal Utilities for NAT](https://en.wikipedia.org/wiki/STUN) (or STUN).  It's used by services that require peer-to-peer connection negotiation (like Skype, Google hangouts, etc).

Here's an example Ruby script that will hit up a few public STUN servers (starting with Google's) and return your found IP:

<script src="https://gist.github.com/bmuller/a1525bd8f7799812867f.js"></script>
