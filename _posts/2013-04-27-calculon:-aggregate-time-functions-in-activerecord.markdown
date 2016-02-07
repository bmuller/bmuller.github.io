---
layout: post
title: "Calculon: Aggregate Time Functions in ActiveRecord"
date: 2013-04-27 15:14
categories: [activerecord, rails, ruby, gems]
---
<img src="/images/Calculon.png" alt="Calculon" class="postimg floatright" />

While [Rails](http://rubyonrails.org) does have the ability to run aggregate functions over certain columns [in ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html) (like sum, average, min, max, etc), there's no way to do this easy while grouping by time buckets.  For instance, it's often the case that you want to know not just the sum of some value between two points in type, but also bucketed by minute (or hour/day/week/month/year/etc).

Using just active record, this can be a bit nasty looking and error prone.  For instance, if I want to get the sum over a column named 'a column' by hour for today, the code would end up looking something like this:

{% highlight ruby %}
grouping = "concat(date(created_at) ' ', hour(created_at), ':00:00')"
SomeModel.sum('a_column').group(grouping).where(['date(created_at) = ?', Date.today)
{% endhighlight %}

Which is a PITA.  ActiveRecord gives so many shortcuts for doing all kinds of things - why not time based groupings?

I think I know the answer to that question now - after going through the trouble of implementing a gem to do this.  The gem is named [calculon](https://github.com/opbandit/calculon), after the [famous actor](http://futurama.wikia.com/wiki/Calculon).  It's even more of a PITA to deal with all of the various time manipulation functions in each database (for instance, sqlite has [only 5](http://www.sqlite.org/lang_datefunc.html) date and time functions) - so I understand why no one has seemingly tackled this problem before.

I started with only MySQL support, and it's made my life quite a bit easier.  Using calculon, the example above becomes:

{% highlight ruby %}
SomeModel.by_hour(:a_column => :sum).on(Date.today)
{% endhighlight %}

You can even make shortcuts if there are certain values you want to perform a given aggregate function over routinely.  For instance, let's say you have a class named Game that has points for team a and team b, and you want to get their average scores.

{% highlight ruby %}
class Game
  attr_accessible :team_a_points, :team_b_points
  calculon_view :points, :team_a_points => :avg, :team_b_points => :avg
end

# get avg points by day
Game.points_by_day.each { |game| 
  puts "#{game.time_bucket}: A Avg: #{game.team_a_points}, B Avg: #{game.team_b_points}"
}

# these work too
Game.points_by_hour
Game.points_by_month
Game.points_by_year
{% endhighlight %}

Check out the code/further docs at [github.com/opbandit/calculon](https://github.com/opbandit/calculon).