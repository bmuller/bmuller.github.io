---
layout: post
title: "HBaseRB: A Ruby HBase Library"
date: 2011-08-01 18:00
categories: [hbase, ruby, hadoop]
---
I recently upgraded the [HBaseRb](https://github.com/bmuller/hbaserb) library I wrote a few months ago.  HBaseRB provides a means for Ruby to interact with [HBase](http://hbase.apache.org/) using a [Thrift](http://thrift.apache.org/) interface.  Most other libraries
(like [hbase-ruby](https://github.com/sishen/hbase-ruby), for instance) use the REST interface provided by HBase.  This may work in many situations, but for our applications at [LivingSocial](http://livingsocial.com) we wanted the benefit of using a binary protocol without the overhead of XML parsing.  

Some Google searching elucidated the fact that [HBaseRb](https://github.com/bmuller/hbaserb) is a bit hard to find, so I thought I'd mention it here.
