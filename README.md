# spark-intro-ruby
Introduction to Apache Spark in Ruby

# What is Apache Spark?
Spark is a general purpose framework for processing large data sets in parallel on a computing cluster. It's used to efficiently crunch big data by distributing the computation across many nodes using an abstraction called a Resilient Distributed Dataset (RDD).

Spark is used to solve similar problems to the Hadoop MapReduce framework. It's gained a lot of ground on MapReduce in terms of market share and developer interest due to it's better performance, generality and simplicity. Spark can run within the Hadoop ecosystem (YARN, HDFS), in a non-Hadoop cluster management system (Mesos) or even as it's own standalone cluster.

In addition to general purpose data analytics processing with RDD's Spark comes with some very powerful more problem domain specific libraries such as
- Spark SQL for querying structured data, data warehousing and BI (Hive compatible)
- Spark Streaming for real-time stream processing (similar to Apache Storm)
- MLib for machine learning (similar to Apache Mahout)
- GraphX for iterative graph computation and ETL (similar to Apache Giraph)

# Spark vs Hadoop MapReduce
Why has Spark gained so much momentum in the big data space - often at the expense of the tried and true Hadoop MapReduce framework?

Spark addresses and improves upon some well known shortcomings of MapReduce. While MapReduce has been a dependable foundation for big data applications during the evolution of data science, Spark has had the advantage of learning from that existing work and has been developed to align with the state of the art and solve a wider class of problems.

## Better Performance
Spark often achieves 10x to 100x better performance than Hadoop MapReduce. It performs especially well for iterative applications in which multiple operations are performed on the same data set.

Spark uses in-memory computation when possible by caching RDDs in memory and only overflows results to disk when necessary. MapReduce depends on it's distributed file system (HDFS) for fault tolerance. MapReduce reads the input for each Map-Reduce step from the file system and writes the results of each step back to the file system. Spark is able to achieve fault tolerance with it's memory cached RDDs using a restricted form of shared memory, based on coarse-grained transformations rather than fine-grained updates to shared state. In other words RDDs are immutable (read-only) and data changes are shared with other nodes by broadcasting the high level transformations that have occurred to big chunks of data rather than broadcasting the individual changed values themselves.

Spark uses a distributed acyclic graph (DAG) computing model. MapReduce treats each Map-Reduce step as a separate, independent job. In applications that consist of multiple steps Spark's DAG has a view of of the entire computation and can make global optimizations using this additional information that MapReduce cannot.

While the DAG model and memory caching are largely responsible for Spark's better performance, Spark also makes practical improvements over MapReduce. For example, MapReduce starts up a new JVM for each Map-Reduce step while Spark keeps an executor JVM running on each node so that dispatched tasks can begin doing real work sooner without the overhead of starting a new JVM.

## Generality and Simplicity
Spark's RDD programming model is more general purpose than MapReduce. In fact, map and reduce are just two of many operations that can be applied to an RDD. In Spark the data set itself is the first class object with a rich set of useful built-in operations such as map, reduce, filter, etc... Programmers are already familiar with this way of thinking from the standard libraries of their favorite object oriented programming languages.

Hadoop MapReduce forces every application into a series of independent jobs that consist of a map operation followed by a reduce operation. The MapReduce programming model was designed at Google Labs to handle a specific problem - web search - and is well suited for that. It was not intended to be a general purpose programming framework. It only evolved and has been used as a general purpose framework to meet the exploding demand for an open source big data processing platform as Hadoop grew. As the variety of big data problems has increased this has resulted in applications that aren't a natural fit for the MapReduce model being shoehorned into MapReduce just so they can run in Hadoop.

Spark is a generalization of MapReduce. It allows problems that are natural for the MapReduce model to be implemented as MapReduce applications but supports other programming models just as well. The more problem-specific add-ons such as Spark Streaming and MLib are implemented as libraries built on the same general purposes RDD model so applications can easily combine these libraries in the same application.

# Programming Languages
## The Supported Languages
Spark itself is written in Scala and runs in a Java Virtual Machine (JVM). The Spark distribution has APIs for writing Spark applications in Scala, Java, Python and R. It even provides interactive command line shells for Scala, Python and R. These languages have long been widely established as big data tools and were natural choices for the market Spark is intended to serve.

## What about Ruby?
Spark does not support writing applications in Ruby. The code examples in this presentation are written in Ruby because this is the Columbus Ruby Brigade. In practice, if you are writing a real Spark application you would almost certainly use one of the languages officially supported by Spark.

However, Ondřej Moravčík has done some excellent work in writing a Ruby wrapper for Spark allowing Spark applications to be written in Ruby. It's a gem called ruby-spark and is available on Github. The code mostly works but the project is not production ready and is more of a proof of concept at this point. If you're a Ruby developer and want to contribute to the future of big data this might be a great project for you to join. Today (3/21/16) ruby-spark appears to somewhat stagnant and could really use additional help.
