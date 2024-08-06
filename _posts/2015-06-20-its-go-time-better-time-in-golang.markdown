---
redirect_to: https://bmuller.wtf
layout: post
title: "It's Go Time: Better Time in Golang"
date: 2015-06-20 14:14
categories: [golang, arrow]
redirect_from:
  - /golang/arrow/2015/06/20/its-go-time:-better-time-in-golang.html
---
Dealing with time in [Go](http://golang.org) is a pain.  The built-in [time package](http://golang.org/pkg/time/) doesn't include much in the way of helper functions.  [Formatting time](http://golang.org/pkg/time/#Time.Format) is especially difficult; unlike many other languages in the [C-family](https://en.wikipedia.org/wiki/List_of_C-family_programming_languages), Go has no support for [`strftime`](http://man7.org/linux/man-pages/man3/strftime.3.html)-based formatting.  Instead, you have to remember a specific date (1/2 3:04:05 2006 -0700) and format that date's values in the form you'd like to mimic.  For instance, if I wanted to format a date into the format `mm/dd/yyyy HH:MM:SS`, here's what you have to do:

{% highlight go %}
fmt.Println("Today's date:", time.Now().Format("01/02/2006 03:04:05"))
{% endhighlight %}

Of course, this typically require having to look up the magic date in the docs to make sure you've got the right month/day/year.  [I'm lazy](http://threevirtues.com/), so naturally I'd rather just have the same [`strftime`](http://man7.org/linux/man-pages/man3/strftime.3.html) format I'm used to.

## Time Flies Like an Arrow; Fruit Flies Like a Banana
The [Arrow library](https://github.com/bmuller/arrow) provides a C-family style `strftime`-based formatting and parsing in Golang (among other helpful date/time functions).  Here's an example of formatting and parsing:

{% highlight go %}
// formatting
fmt.Println("Current date: ", arrow.Now().CFormat("%Y-%m-%d %H:%M:%S"))

// parsing
parsed, _ := arrow.CParse("%Y-%m-%d", "2015-06-03")
fmt.Println("Some other date: ", parsed)
{% endhighlight %}

You can also get the time at the beginning of the minute / hour / day / week / month / year.

{% highlight go %}
t := arrow.Now().AtBeginningOfHour().CFormat("%Y-%m-%d %H:%M:%S")
fmt.Println("The first second of this hour was at:", t)

t = arrow.Now().AtBeginningOfWeek().CFormat("%Y-%m-%d %H:%M:%S")
fmt.Println("The first second of the week was at:", t)
{% endhighlight %}

You can also more easily sleep until specific times:

{% highlight go %}
// sleep until the next minute starts
arrow.SleepUntil(arrow.NextMinute())
fmt.Println(arrow.Now().CFormat("%H:%M:%S"))
{% endhighlight %}

There are also helpers to get today, yesterday, and UTC times:

{% highlight go %}
day := arrow.Yesterday().CFormat("%Y-%m-%d")
fmt.Println("Yesterday: ", day)

dayutc := arrow.UTC().Yesterday().CFormat("%Y-%m-%d %H:%M")
fmt.Println("Yesterday, UTC: ", dayutc)

newyork := arrow.InTimezone("America/New_York").CFormat("%H:%M:%s")
fmt.Println("Time in New York: ", newyork)
{% endhighlight %}

And for generating ranges when you need to iterate:

{% highlight go %}
// Print every minute from now until 24 hours from now
for _, a := range arrow.Now().UpTo(arrow.Tomorrow(), arrow.Minute) {
     fmt.Println(a.CFormat("%Y-%m-%d %H:%M:%S"))
}
{% endhighlight %}

Much easier.  There's more magic not listed here; check out the docs on [godoc.org](https://godoc.org/github.com/bmuller/arrow/lib) for the full list.
