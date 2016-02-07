---
layout: post
title: "First Thoughts on Scala"
date: 2013-07-03 16:30
categories: []
---


http://ofps.oreilly.com/titles/9780596155957/RoundingOutTheEssentials.html

val dogBreeds = List("Doberman", "Yorkshire Terrier", "Dachshund",
                     "Scottish Terrier", "Great Dane", "Portuguese Water Dog")
val filteredBreeds = for {
  breed <- dogBreeds
  if breed.contains("Terrier")
  if !breed.startsWith("Yorkshire")
} yield breed

tuples - wtf = tuple._1, tuple_2 different from accessing members of array
map foreach gives you a tuples

options...don't make sense - why not null - getOrElse is the same as val || ""


http://ofps.oreilly.com/titles/9780596155957/Traits.html
structural type

these seem to negate the whole static thing - seems like (enforced) duck typing


http://www.scala-sbt.org/release/docs/Getting-Started/Basic-Def.html
"sbt needs some kind of delimiter to tell where one expression stops and the next begins."
but a newline isn't a delimiter


https://github.com/debasishg/scala-redis/blob/master/project/ScalaRedisProject.scala
THERE's XML IN THAT - compare with
https://github.com/redis/redis-rb/blob/master/redis.gemspec
or
https://github.com/mranney/node_redis/blob/master/package.json


array concatantion - ++ - why not +?

Tuples?  WTF - _1, _2, _3

Map.foreach yields tuples? wtf?