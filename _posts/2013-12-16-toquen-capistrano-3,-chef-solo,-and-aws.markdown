---
layout: post
title: "Toquen: Capistrano 3, Chef-solo, and AWS"
date: 2013-12-16 10:52
categories: [sysadmin, aws, capistrano, chef]
---
<img alt="A Toque" class="postimg small opbandit floatright" src="/images/toque.jpg" />

[Toquen](https://github.com/bmuller/toquen) combines [Capistrano 3](http://www.capistranorb.com), [Chef](http://www.getchef.com), and [AWS instance tags](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) into one bundle of joy.  Instance roles are stored in AWS tags and **Toquen** can suck those out, put them into data bags for chef, and create stages in capistrano.  You can then selectively run chef on individual servers or whole roles that contain many servers with simple commands.

A [Toque](http://en.wikipedia.org/wiki/Toque) is a chef's cap.  Chef + cap = Toque.

## Features
Toquen is a gem - and simply extends capistrano with tasks to make AWS tag information (roles, names, etc) available both within Chef as well as in capistrano as stages.  You can then run [chef-solo](http://docs.opscode.com/chef_solo.html) on single servers, all servers with a given role, or on all servers.  For instance, the following command will create all relevant stages for capistrano as well as create a *servers* [data bag](http://docs.opscode.com/essentials_data_bags.html):

{% highlight bash %}
cap update_roles
{% endhighlight %}

And then will run chef-solo on all machines:

{% highlight bash %}
cap all cook
{% endhighlight %}

There's also a bootstrapping feature that can be run to initialize a server.  The process will:

1. Update all packages
1. Sets the hostname to be whatever you set as value for the Name tag in AWS
1. Set ruby 1.9.3 as the default ruby
1. Install rubygems
1. Install the chef and bundler gems
1. Reboot

Right now the only supported distributions are Ubuntu and Debian, but alternatives like Redhat could easily be added by creating additional templates for the bootstrapping script.

## Installation
Before beginning, you should already understand how [chef-solo](http://docs.opscode.com/chef_solo.html) works and have some cookbooks, roles defined, and at least a folder for data_bags (even if it's empty).  The rest of this guide assumes you have these ready as well as an AWS PEM key and [access credentials](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).

Generally, it's easiest if you start off in an empty directory.  First, create a file named *Gemfile* that contains these lines:

{% highlight ruby %}
source 'http://rubygems.org'
gem 'toquen'
{% endhighlight %}

Then, create a file named *Capfile* that contains the following line:

{% highlight ruby %}
require 'toquen'
{% endhighlight %}

And then on the command line execute:

{% highlight bash %}
bundle
cap toquen_install
{% endhighlight %}

This will create a config directory with a file named *deploy.rb*.  Edit this file, setting the location of your AWS key, AWS credentials, and chef cookbooks/data bags/roles.

Then, in AWS, create an [AWS instance tag](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) named "Roles" for each instance, using a space separated list of chef roles as the value.  The "Name" tag must also be set or the instance will be ignored.

Then, run:

{% highlight bash %}
cap update_roles
{% endhighlight %}

This will create a data_bag named *servers* in your data_bags path that contains one item per server name, as well as create stages per server and role for use in capistrano.

At this point you can run chef-solo using the cook task:

{% highlight bash %}
# one server
cap server-<server name> cook

# Or a all the servers with a given role
cap <role name> cook

# Or on all servers
cap all cook
{% endhighlight %}

## Alternatives
There are a few alternatives (including [toque](https://github.com/jgraichen/toque) and other [toque](https://github.com/spikegrobstein/toque)) out there - but most haven't yet moved to the magic available in capistrano 3 and none can pull roles out of AWS.  Toquen is small and delightful and will play nice if you already have a ton of cap tasks.

To see the rest of the docs, check out the [toquen github page](https://github.com/bmuller/toquen).
