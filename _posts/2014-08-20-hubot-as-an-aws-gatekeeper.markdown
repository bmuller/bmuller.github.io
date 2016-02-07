---
layout: post
title: "Hubot as an AWS Gatekeeper"
date: 2014-08-20 11:23
categories: [hubot, aws]
---

<a target="_blank" style="float: right; padding: 0px; margin: 0px;" href="http://www.computerhistory.org/collections/catalog/102633881"><img src="/images/hubot.jpg" alt="Hubot" class="postimg medium opbandit" /></a>

On AWS, it's easy to fall into a situation when you're using the equivalent of a poor man's VPN.  Each time you want to access a server, you go into the AWS console online and authorize some ports in a security group for your current IP address.  Then you forget to remove those rules, naturally.  What if there was a way to just externally monitor your online presence, and then open access when you show up online and remove that access when you sign off...  Like some sort of presence protocol, perhaps with messaging...  That's extensible too.. Like some sort of [Extensible Messaging and Presence Protocol](http://xmpp.org/)...

But wait, such a thing exists.  And it's not constrained to XMPP - most other chat protocols have a way to track presence, and most of them can be accessed by Github's [Hubot](https://hubot.github.com/).  So I decided to just build a Hubot script that will open ports in security groups when I sign online, and close them when I leave.  Easy.

Installation and usage is easy - see the [hubot-aws-sesame github page](https://github.com/bmuller/hubot-aws-sesame) for more info.  The way Hubot can get your IP when you sign online is a bit tricky, but it works.  When you sign online, Hubot sends you an image URL for an image serviced by Hubot's built in web server.  Most chat clients will automaticaly load the image, giving Hubot access to your IP.  Wooo - easy poort man's auto-connecting VPN!

Github repo is [here](https://github.com/bmuller/hubot-aws-sesame), NPM package [here](https://www.npmjs.org/package/hubot-aws-sesame).

