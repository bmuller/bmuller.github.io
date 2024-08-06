---
redirect_to: https://bmuller.wtf
layout: post
title: "Campfirer.com - A Jabber to Campfirenow.com Gateway"
date: 2011-09-13 17:21
categories: [campfirer_project, campfirenow, jabber]
---
[Campfire](http://campfirenow.com) is a web-based group chat service that is directed at businesses.  Rather than using a standard protocol, the folk at [37 Signals](http://37signals.com) decided to invent their own.  This has led to the necessary creation of a number of custom clients to interact with the API using their unique, one-of-a-kind protocol (for those who don't want to have to chat in a browser window).

I heart [Jabber (XMPP)](http://xmpp.org).  There's a good reason [Google](http://en.wikipedia.org/wiki/Google_Talk#Interoperability) and [Facebook](http://developers.facebook.com/docs/chat/) chose that protocol to power their chat.  I have no idea why 37 Signals didn't use Jabber too.  Maybe they're [mavericks](http://www.youtube.com/watch?v=sBzXVHoF-pI). 

Naturally, I'd like to be able to use one of many [Jabber clients](http://xmpp.org/xmpp-software/clients/) to access Campfire, along with all of my other Jabber based accounts.  To do this, I wrote a [Jabber Component](http://xmpp.org/extensions/xep-0114.html).  It provides Multi-User Chat (MUC) support for Jabber servers that utilizes Campfire's API, so you can "join" a room, "talk", and see other posts by other users.  It's called Campfirer (campfire + jabber = campfirer).

I've set up a running instance of the service at [campfirer.com](http://campfirer.com).  A description of how to download / set up the code for your own Jabber server can be found there.

The code and more info can be found on the [github project page](http://github.com/bmuller/campfirer).  Pull requests welcome.