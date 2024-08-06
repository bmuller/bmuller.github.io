---
redirect_to: https://bmuller.wtf
layout: post
title: Generating Config Files Per Environment
categories: [linux, sysadmin, ruby]
---
***Note: This is now a gem named [configulator](https://rubygems.org/gems/configulator).***

Lately I've been writing scripts to automate the deployment of a [Hadoop](http://hadoop.apache.org) cluster at [LivingSocial](http://livingsocial.com).
One of the problems I've run into is that there are many, many config files which often contain some of the same values in others and which need
to have different values depending on the machine/environment (i.e., distributed vs. your local machine vs. a test cluster).  What I needed was
a tool that could take a config file and template files as input and then output the template files with the correct configuration values 
substituted.  Additionally, there should be a way of specifying default values, and then overriding on the necessary ones per environment.

I couldn't find anything that seemed to do what I wanted, so I whipped something up in Ruby.  The result:
 1. Uses embedded Ruby (ERB) which not only comes standard with Ruby, but also allows you to put Ruby code in your template files
 2. Uses a YAML file for configuration.  If a default environment exists, all other environments extend it.
 3. Is a small, simple class that can be used either in code or as a script run from the command line

## YAML Config File
The YAML configuration file (say, at *config.yml*) is fairly simple, but can contain embedded ruby and in the values as well as 
references to other values:
{% highlight yaml %}
default:
   username: myuser
   password: mypass
   hostname: localhost
   rootpath: /root/path
   myfiles: <%= rootpath %>/files

localmachine:
   hostname: someserver
   rootpath: /home/bmuller
   date: <%= Date.today.to_s %>
{% endhighlight %}

## Template File
Template files can contain any text in any format you want.  You just embed the configuration values as ruby variables:
{% highlight xml %}
<xml>
  <date><%= date %></date>
  <time><%= Time.now %></time>
  <dbaccess>
    <hostname><%= hostname %></hostname>
    <username><%= username %></username>
  </dbaccess>
  <myfiles><%= myfiles %></myfiles>
</xml>
{% endhighlight %}

## Conversion
To convert the template file, use the *ConfigTemplate* class:
{% highlight ruby %}
require 'config_template'

# Construct with the config file location and the environment to use
ct = ConfigTemplate.new 'config.yml', 'localmachine'

# Convert the template file
ct.convert_file 'template.xml', 'myconfig.xml'

# You can access variables by name if you need them
puts ct.myfiles
{% endhighlight %}

This will output:
{% highlight xml %}
<xml>
  <date>2010-10-27</date>
  <time>Thu Oct 27 08:47:18 -0400 2010</time>
  <dbaccess>
    <hostname>someserver</hostname>
    <username>myuser</username>
  </dbaccess>
  <myfiles>/home/bmuller/files</myfiles>
</xml>
{% endhighlight %}

## The ConfigTemplate class
<script src="http://gist.github.com/650421.js?file=config_template.rb">
</script>

