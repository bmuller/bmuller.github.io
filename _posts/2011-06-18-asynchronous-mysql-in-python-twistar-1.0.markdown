---
layout: post
title: "Asynchronous MySQL in Python: Twistar 1.0"
date: 2011-06-18 16:13
categories: [python, twisted, twistar_project]
---
After a few more updates and contributions, I've finally decided to release version 1.0 of [Twistar](http://findingscience.com/twistar).  The recent work and contributions have brought it in line with what I consider to be a feature rich enough library ready for a version one release.

Description from the website:

Twistar is a Python implementation of the [active record pattern](http://en.wikipedia.org/wiki/Active_record_pattern) (also known as an object-relational mapper or ORM) that uses the [Twisted](http://twistedmatrix.com/trac/) framework's [RDBMS support](http://twistedmatrix.com/documents/current/core/howto/rdbms.html) to provide a non-blocking interface to relational databases.

Twistar currently features:
* A thoroughly asynchronous API
* Object validations (and support for the easy creation of new validation methods)
* Support for callbacks before saving / creating / updating / deleting 
* Support for object relational models that can be queried asynchronously
* A simple interface to [DBAPI](http://www.python.org/dev/peps/pep-0249/) objects
* A framework to support any relational database that has a module that implements the [Python Database API Specification v2.0](http://www.python.org/dev/peps/pep-0249/) (MySQL, PostgreSQL, and SQLite are all supported now)
* Support for object polymorphism
* Unit tests

For more information, check out [the website](http://findingscience.com/twistar) or [the github page](http://github.com/bmuller/twistar).

