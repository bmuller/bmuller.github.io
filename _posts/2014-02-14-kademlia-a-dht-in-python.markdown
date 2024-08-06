---
redirect_to: https://bmuller.wtf
layout: post
title: "Kademlia: A DHT in Python"
date: 2014-02-14 16:35
categories: [python, kademlia, dht]
redirect_from:
  - /python/kademlia/dht/2014/02/14/kademlia:-a-dht-in-python.html
---

<a href="http://en.wikipedia.org/wiki/Distributed_hash_table"><img class="postimg small floatright" src="/images/DHT_en.svg" /></a>

A [distributed hash table (DHT)](http://en.wikipedia.org/wiki/Distributed_hash_table) is a decentralized dictionary that is comprised of many nodes that each store a portion of a key/value lookup table.  Any participating node can write to and read from the entire hash table.

The [Kademlia distributed hash table](http://en.wikipedia.org/wiki/Kademlia) is one of the better known DHT descriptions, and it's used by [BitTorrent](http://en.wikipedia.org/wiki/BitTorrent) for trackerless torrents and by the [Gnutella](http://en.wikipedia.org/wiki/Gnutella) network (originally "LimeWire").

I couldn't find a good implementation in Python (that followed the paper and wasn't buggy), so I wrote one.  Naturally, it uses [Twisted](https://twistedmatrix.com) to provide asynchronous communication.  The nodes communicate using [RPC over UDP](https://github.com/bmuller/rpcudp) to communiate, meaning that it is capable of working behind a [NAT](http://en.wikipedia.org/wiki/NAT).

The library aims to be as close to a reference implementation of the [Kademlia paper](http://pdos.csail.mit.edu/~petar/papers/maymounkov-kademlia-lncs.pdf) as possible.

Check out the code and examples here - [github.com/bmuller/kademlia](http://github.com/bmuller/kademlia).
