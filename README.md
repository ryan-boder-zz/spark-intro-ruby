# spark-intro-ruby
Introduction to Apache Spark in Ruby

# What is Apache Spark?
[Apache Spark](http://spark.apache.org/) is a general purpose framework for processing large data sets in parallel on a computing cluster. It's used to efficiently crunch big data by distributing the computation across many nodes using an abstraction called a [Resilient Distributed Dataset](http://spark.apache.org/docs/latest/programming-guide.html#resilient-distributed-datasets-rdds) (RDD). It was originally developed at [UC Berkeley AMPLab](https://amplab.cs.berkeley.edu/projects/spark-lightning-fast-cluster-computing/).

Spark is used to solve similar problems to the [Hadoop MapReduce framework](http://hortonworks.com/hadoop/mapreduce/). It's [gained a lot of ground on MapReduce](https://adtmag.com/articles/2016/01/20/syncsort-hadoop-survey.aspx) in terms of market share and developer interest due to it's better performance, generality and simplicity. Spark can run within the Hadoop ecosystem ([YARN](http://hortonworks.com/hadoop/yarn/), [HDFS](http://hortonworks.com/hadoop/hdfs/)), in a non-Hadoop cluster management system ([Mesos](http://mesos.apache.org/)) or even as it's own [standalone cluster](http://spark.apache.org/docs/latest/spark-standalone.html).

In addition to general purpose data analytics processing with RDD's Spark comes with some very powerful more problem domain specific libraries such as
- [Spark SQL](http://spark.apache.org/sql/) for querying structured data, data warehousing and BI ([Apache Hive](https://hive.apache.org/) compatible)
- [Spark Streaming](http://spark.apache.org/streaming/) for real-time stream processing (similar to [Apache Storm](http://storm.apache.org/))
- [MLlib](http://spark.apache.org/mllib/) for machine learning (similar to [Apache Mahout](http://mahout.apache.org/))
- [GraphX](http://spark.apache.org/graphx/) for iterative graph computation and ETL (similar to [Apache Giraph](http://giraph.apache.org/))

# Spark vs Hadoop MapReduce
Why has Spark gained so much momentum in the big data space - often at the expense of the tried and true Hadoop MapReduce framework?

Spark [addresses some well known shortcomings of MapReduce](http://www.computerweekly.com/feature/Spark-versus-MapReduce-which-way-for-enterprise-IT). While MapReduce has been a dependable foundation for big data applications through the evolution of data science, Spark has had the advantage of learning from that existing work and has been developed to align with the state of the art and solve a wider class of problems.

## Better Performance
Spark often achieves [10x to 100x better performance](http://spark.apache.org/news/spark-wins-daytona-gray-sort-100tb-benchmark.html) than Hadoop MapReduce. It performs especially well for iterative applications in which multiple operations are performed on the same data set.

Spark uses in-memory computation when possible by memory caching RDDs and only overflows results to disk when necessary. MapReduce depends on it's distributed file system (HDFS) for fault tolerance. MapReduce reads the input for each Map-Reduce step from the file system and writes the results of each step back to the file system. Spark is able to achieve fault tolerance with it's memory cached RDDs [using a restricted form of shared memory, based on coarse-grained transformations rather than fine-grained updates to shared state](https://www.usenix.org/system/files/conference/nsdi12/nsdi12-final138.pdf). In other words RDDs are immutable (read-only) and data changes are shared with other nodes by broadcasting the high level transformations that have occurred to big chunks of data rather than broadcasting the individual changed values themselves.

Spark uses a [distributed acyclic graph](http://www.srinivastata.com/tez/directed-acyclic-graph-dag-strength-of-spark-and-tez/) (DAG) computing model. MapReduce treats each Map-Reduce step as a separate, independent job. In applications that consist of multiple steps Spark's DAG has a view of of the entire computation and can make global optimizations using this additional information that MapReduce cannot.

While the DAG model and memory caching are largely responsible for Spark's better performance, Spark also makes practical improvements over MapReduce. For example, MapReduce starts up a new JVM for each Map-Reduce step while [Spark keeps an executor JVM running on each node](https://www.quora.com/What-makes-Spark-faster-than-MapReduce) so that dispatched tasks can begin doing real work sooner without the overhead of starting a new JVM.

## Generality and Simplicity
Spark's RDD programming model is more general purpose than MapReduce. In fact, map and reduce are just two of [many operations](http://spark.apache.org/docs/latest/programming-guide.html#rdd-operations) that can be applied to an RDD. In Spark the data set itself is the first class object with a rich set of useful built-in operations such as map, reduce, filter, etc... Programmers are already familiar with this way of thinking with collections in object oriented programming languages.

Hadoop MapReduce forces every application into a series of independent jobs that consist of a map operation followed by a reduce operation. The MapReduce programming model was designed at [Google Labs](http://research.google.com/archive/mapreduce.html) to handle web search and is well suited for that. It was not intended to be a general purpose programming framework. It evolved as such and has been used as a general purpose framework to meet the exploding demand for an open source big data processing platform as Hadoop has grown. As the variety of big data problems has increased this has resulted in applications that aren't a natural fit for the MapReduce model being shoehorned into MapReduce just so they can run in a Hadoop cluster.

Spark is a generalization of MapReduce. It allows problems that are natural for the MapReduce model to be implemented as MapReduce applications but supports other programming models just as well. The more domain specific add-ons such as Spark Streaming and MLlib are implemented as libraries built on the same general purposes RDD model so applications can easily combine these libraries in the same application.

# Programming Languages
## The Supported Languages
Spark itself is written in Scala and runs in a Java Virtual Machine (JVM). The Spark distribution has APIs for writing Spark applications in [Scala](http://www.scala-lang.org/), [Java](https://www.java.com), [Python](https://www.python.org/) and [R](https://www.r-project.org). It even provides interactive command line shells for Scala, Python and R. These languages have long been widely established as big data tools and were natural choices for the market Spark is intended to serve.

## What about Ruby?
Spark does not support writing applications in [Ruby](https://www.ruby-lang.org). The code examples in this presentation are written in Ruby because this is the [Columbus Ruby Brigade](http://columbusrb.com/). In practice, if you are writing a real Spark application you would almost certainly use one of the languages officially supported by Spark.

However, [Ondřej Moravčík](https://github.com/ondra-m) has done some excellent work in writing a Ruby wrapper for Spark allowing Spark applications to be written in Ruby. It's a gem called [Ruby-Spark](https://github.com/ondra-m/ruby-spark) with a nice [getting started tutorial](https://github.com/ondra-m/ruby-spark). The code mostly works but the project is not production ready and [is more of a proof of concept](https://github.com/ondra-m/ruby-spark/issues/6) at this point. If you're a Ruby developer and want to contribute to the future of big data this might be a great project for you to join. Today (3/21/16) Ruby-Spark [appears to be somewhat stagnant](https://github.com/ondra-m/ruby-spark/issues/29) and could really use additional help.

# Installation & Setup
Follow the Ruby-Spark installation instructions in the [tutorial](http://ondra-m.github.io/ruby-spark/) or in the [README](https://github.com/ondra-m/ruby-spark).

Verify that you can run the ruby-spark interactive shell.
```
ruby-spark shell
```

Clone the [Introduction to Apache Spark in Ruby](https://github.com/ryan-boder/spark-intro-ruby) project and cd into that directory.
```
git clone https://github.com/ryan-boder/spark-intro-ruby.git
cd spark-intro-ruby
```

# Application Template

Ruby-Spark applications need a little boilerplate code. An example application template looks like this.

```ruby
require 'ruby-spark'

Spark.config do
  set_app_name 'My Application Name'
  set_master   'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

# Your application code goes here

Spark.stop
```

# Creating an RDD
To do anything in Spark you'll need to [load data](https://github.com/ondra-m/ruby-spark/wiki/Loading-data) into an [RDD](http://www.rubydoc.info/gems/ruby-spark/Spark/RDD). You can convert an existing collection into an RDD...
```ruby
rdd = $sc.parallelize(0..1000)
```

or you can read an RDD from the file system. Spark can create an RDD with any [Hadoop InputFormat](https://hadoop.apache.org/docs/r2.7.2/api/org/apache/hadoop/mapred/InputFormat.html). For simplicity we will just use a text file on in the local file system as our data source.
```ruby
rdd = $sc.text_file('data/atlas.txt')
```

# Example 1: Counting Items
A really simple example is to create an [RDD](http://www.rubydoc.info/gems/ruby-spark/Spark/RDD) and use it to count the number of items in the data set. In this case items are lines in a text file.

```ruby
rdd = $sc.text_file('data/fruit.txt')
puts '---- Number of Lines: ' + rdd.count.to_s
```
```
ruby bin/example1.rb
```

# Example 2: Map Reduce
Spark can easily handle Map Reduce applications with an [RDD](http://www.rubydoc.info/gems/ruby-spark/Spark/RDD). This example takes an input range or 0 to 1000, doubles all the values making it 0 to 2000, sums all the values and divides by the total count to calculate the average.

```ruby
input = $sc.parallelize(0..1000)
doubled = input.map(lambda { |x| x * 2 })
summed = doubled.reduce(lambda { |sum, x| sum + x })
average = summed / input.count
puts '---- Average: ' + average.to_s
```
```
ruby bin/example2.rb
```

# Example 3: Word Count
The obligatory Hello World of data analytics is to count the number of each word in a text file. We can accomplish this by splitting the file by whitespace, mapping it to a pairs (2 element arrays) containing the word (key) and a count of 1 (value), then reducing the pairs by key (the word) summing up the counts.

```ruby
text_file = $sc.text_file('data/fruit.txt')
words = text_file.flat_map(lambda { |x| x.split() })
pairs = words.map(lambda { |word| [word, 1] })
counts = pairs.reduce_by_key(lambda { |a, b| a + b })
puts '---- Word Counts: ' + counts.collect.to_s
```
```
ruby bin/example3.rb
```

# Example 4: Better Word Count
The previous word count was not quite as robust as we would like it to be. Let's take it a little further. This time we'll
- Split with a regular expression to properly handle newlines and special characters
- Convert words to lower case so Hello and hello are counted as the same word
- Sort the results by word count from highest to lowest
- Write the results to a file so we can word count files with many words

```ruby
text_file = $sc.text_file('data/atlas.txt')
words = text_file.flat_map(lambda { |x| x.split(/[\s.,!?"']+/) })
pairs = words.map(lambda { |word| [word.downcase, 1] })
counts = pairs.reduce_by_key(lambda { |a, b| a + b })
results = counts.sort_by(lambda { |x| x[1] }, false).collect

File.open('example4-output.txt', 'w') do |file|
  results.each { |x| file.puts(x[0] + ': ' + x[1].to_s) unless x[0].empty? }
end
```
```
ruby bin/example4.rb
less example4-output.txt
```

# Conclusion
We've covered what Apache Spark is and why it's having such an impact on big data. We've compared Spark to the Hadoop MapReduce framework and showed it's advantages. We've covered the programming languages officially supported by Spark and showed an fledgling 3rd party open source project that allows Spark programs to be written in Ruby. We've written a few basic Spark examples in Ruby to demonstrate how the Spark programming model works.
