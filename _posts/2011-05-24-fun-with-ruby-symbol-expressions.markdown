---
redirect_to: https://bmuller.wtf
layout: post
title: "Fun with Ruby Symbol Expressions"
date: 2011-05-24 19:02
categories: [ruby, metaprogramming]
---
Groupon released an interesting extension to the **Symbol#to_proc** method named [symbol_expressions](https://github.com/groupon/symbol_expressions) over a year ago (I didn't notice it until recently).  It allows you to compose procs based on combinations of existing methods.  For instance, 
to split and then join strings:

{% highlight ruby %}
["foo", "bar"].map(&:split['']+:join['_'])
# => ["f_o_o", "b_a_r"]
{% endhighlight %}

I thought this was nifty, but the syntax is a bit odd (brackets are not generally used as argument list boundaries).  Additionally, this sort of **Proc** composition is something a **Proc** should know how to create, but it doesn't make sense to have a **Symbol** keeping track of a list of other **Symbol**s that have been "added" to it (especially via an [internal array class](https://github.com/groupon/symbol_expressions/blob/master/lib/symbol_expressions.rb#L80)).  It just seems like a bit of a hack to have **Symbols** acting as lists of other **Symbol**s.  

Based on these ideas, I reduced the *symbol_expressions* lib to the following lines:

<script src="https://gist.github.com/989964.js">
</script>

With this little bit of code (which simply prefixes argument lists with a **|** symbol), you can now do stuff like this:
{% highlight ruby %}
# composition using Proc (rather than Symbols that have lists of Symbols in them)
splitjoin = Proc.from_sym(:split | '', :join | " ", :upcase)
splitjoin.call "what"
# => "W H A T"

["foo", "bar"].map(&splitjoin)
# => ["F O O", "B A R"]

["foo", "bar"].map(&:split | '')
# => [["f", "o", "o"], ["b", "a", "r"]]
{% endhighlight %}

Fun stuff.  Ruby consistently amazes me with its expressiveness.
