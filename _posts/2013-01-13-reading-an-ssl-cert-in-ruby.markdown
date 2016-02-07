---
layout: post
title: "Reading an SSL Cert in Ruby Over a Socket"
date: 2013-01-13 14:27
categories: [ruby, ssl]
---
I couldn't find any examples of reading a SSL certificate from a socket connection, so I thought I'd share my approach here.  Ultimately, I just wanted to get the X509 certificate information for a few websites that have HTTPS - which this bit of code will do.

{% highlight ruby %}
require 'socket'
require 'openssl'

tcp_client = TCPSocket.new("example.com", 443)
ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client)
ssl_client.connect
cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
ssl_client.sysclose
tcp_client.close
  
certprops = OpenSSL::X509::Name.new(cert.issuer).to_a
issuer = certprops.select { |name, data, type| name == "O" }.first[1]
results = { 
            :valid_on => cert.not_before,
            :valid_until => cert.not_after,
            :issuer => issuer,
            :valid => (ssl_client.verify_result == 0)
          }
{% endhighlight %}

The last line creates a hash that contains when the cert became valid, when it will become invalid, who issued it, and whether or not it actually is valid.
