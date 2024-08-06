---
redirect_to: https://bmuller.wtf
layout: post
title: "Twisted adbapi.ConnectionLost and MySQLdb"
date: 2012-03-29 19:45
categories: [twisted, mysql, twistar]
---
[Twisted's connection pool](http://twistedmatrix.com/trac/browser/tags/releases/twisted-12.0.0/twisted/enterprise/adbapi.py) doesn't support automagical reconnecting, which means that if the [MySQLdb](http://mysql-python.sourceforge.net/MySQLdb.html) driver loses it's connection, you get a

{% highlight python %}
_mysql_exceptions.OperationalError: (2006, 'MySQL server has gone away')
{% endhighlight %}

exception that doesn't result in a new connection being established for the failed query.  Here's the full trace:

{% highlight python %}
2012-03-29 19:43:02-0400 [HTTPChannel,0,127.0.0.1] Rollback failed
Traceback (most recent call last):
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/python/context.py", line 118, in callWithContext
    return self.currentContext().callWithContext(ctx, func, *args, **kw)
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/python/context.py", line 81, in callWithContext
    return func(*args,**kw)
  File "build/bdist.macosx-10.7-intel/egg/twistar/dbconfig/mysql.py", line 24, in _runInteraction

  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/enterprise/adbapi.py", line 455, in _runInteraction
    conn.rollback()
--- <exception caught here> ---
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/enterprise/adbapi.py", line 56, in rollback
    self._connection.rollback()
  _mysql_exceptions.OperationalError: (2006, 'MySQL server has gone away')
         
2012-03-29 19:43:02-0400 [HTTPChannel,0,127.0.0.1] Rollback failed
Traceback (most recent call last):
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/python/threadpool.py", line 207, in _worker
    result = context.call(ctx, function, *args, **kwargs)
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/python/context.py", line 118, in callWithContext
    return self.currentContext().callWithContext(ctx, func, *args, **kw)
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/python/context.py", line 81, in callWithContext
    return func(*args,**kw)
  File "build/bdist.macosx-10.7-intel/egg/twistar/dbconfig/mysql.py", line 24, in _runInteraction
			           
  --- <exception caught here> ---
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/enterprise/adbapi.py", line 455, in _runInteraction
    conn.rollback()
  File "/Library/Python/2.7/site-packages/Twisted-12.0.0-py2.7-macosx-10.7-intel.egg/twisted/enterprise/adbapi.py", line 70, in rollback
    raise ConnectionLost()
  twisted.enterprise.adbapi.ConnectionLost:
{% endhighlight %}

This is a huge PITA.  To take care of this in [Twistar](http://findingscience.com/twistar/), I added a reconnecting class.  A <code>ReconnectingMySQLConnectionPool</code> can be used instead of a <code>adbapi.ConnectionPool</code>:

{% highlight python %}
from twisted.enterprise import adbapi
from twistar.registry import Registry
from twistar.dbobject import DBObject
from twistar.dbconfig.mysql import ReconnectingMySQLConnectionPool

Registry.DBPOOL = ReconnectingMySQLConnectionPool("MySQLdb"
                                                  user="username",
                                                  passwd="pass",
                                                  db="dbname",
                                                  host="host",
                                                  cp_reconnect=True)

class User(DBObject):
     pass

def done(user):
     print "A user was just created with the name %s" % user.first_name

u = User(first_name="John", last_name="Smith", age=25)
u.save().addCallback(done)

{% endhighlight %}

When using the <code>ReconnectingMySQLConnectionPool</code>, any connection breaks from MySQL will result in the <code>ConnectionPool</code> reconnecting and attempting to execute a transaction a second time.  This at least alleviates the problem when using the [MySQLdb driver](http://mysql-python.sourceforge.net/MySQLdb.html).
