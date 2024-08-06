---
redirect_to: https://bmuller.wtf
layout: post
title: "Installing R on OS X with Readline"
date: 2011-01-03 14:04
categories: [r, os_x]
excerpt_separator: ""
---
When attempting to install R on OS X with [homebrew](https://github.com/mxcl/homebrew) I ran into the following error:
{% highlight bash %}
...
checking for history_truncate_file... no
configure: error: --with-readline=yes (default) and headers/libs are not available
Exit status: 1

http://github.com/mxcl/homebrew/blob/master/Library/Formula/r.rb#L18
{% endhighlight %}

Turns out there is an issue with the default Mac readline lib being old and moldy.  While you can compile without readline support, that makes the read-eval-print loop really hard to interact with.  To fix the problem, you need to add readline as a dependency and change the CPPFLAGS and LDFLAGS environment variables to look in the right directory.  Type:
{% highlight bash %}
brew edit R
{% endhighlight %}
and then add the depends line and the environment variable lines as shown in:

<script src="https://gist.github.com/763782.js?file=r.rb">
</script>

After that, save and close the file, and then you should be good to go:
{% highlight bash %}
brew install R
{% endhighlight %}