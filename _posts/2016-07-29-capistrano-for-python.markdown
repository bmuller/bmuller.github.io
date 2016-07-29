---
layout: post
title: "Capistrano for Python"
date: 2016-07-29 11:57
categories: [python, fabric]
---
In the Python world, [Fabric](http://www.fabfile.org) seems like the *de facto* method for deploying code.  At its core, though, Fabric is just a way to streamline the use of SSH, much like Ruby's [SSHKit](https://github.com/capistrano/sshkit).  Reliable deployments, however, typically involve more than just running a few commands on a remote server.  For instance, Ruby's [Capistrano](http://capistranorb.com) builds on it's underlying ssh library SSHKit and provides a lot of useful functionality, like:

1. the ability to inject tasks in a dependency chain (before you run `TaskA`, always run `TaskB`)
1. configuration variables with values that are role specific, where each server has one or more roles
1. configuration values that are evaluated at run time (i.e., the ability to have values that are `callable` at runtime)
1. the ability to define a sane flow convention for deployment and then give people the ability to override/inject only what they need.  [Convention over configuration!](https://en.wikipedia.org/wiki/Convention_over_configuration)

I feel like there should be a way to reliably do these things, and Fabric isn't enough.  So I made a project called [Fake](https://github.com/bmuller/fake) - for *Fabric* + *Make* (in the same way that [Rake](http://docs.seattlerb.org/rake/) is *Ruby* + *Make*).  It includes all of this functionality, including Capistrano's default deploy tasks for reliable code checkouts (and super fast rollbacks!).

Check it out at [https://github.com/bmuller/fake](https://github.com/bmuller/fake) for documentation and examples.
