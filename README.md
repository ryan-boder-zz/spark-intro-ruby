# spark-intro-ruby
Introduction to Apache Spark in Ruby

# What is Apache Spark?
Spark is a general purpose framework for processing large data sets in parallel on a computing cluster. It's used to efficiently crunch big data by distributing the the computation across many nodes using an abstraction called a Resilient Distributed Dataset (RDD).

Spark is used to solve similar problems to the Hadoop MapReduce framework. It's gained a lot of ground on MapReduce in terms of market share and developer interest due to better performance, generality and simplicity. Spark can run within the Hadoop ecosystem (YARN, HDFS), in non-Hadoop cluster management systems (Mesos) or even as it's own built-in standalone cluster.

In addition to general purpose data analytics processing with RDD's Spark comes with some very powerful problem domain specific libaries such as
- Spark SQL (Hive compatible) for querying distributed structured data, data warehousing and BI
- Spark Streaming for real-time stream processing (similar to Apache Storm)
- MLib for machine learning (simular to Apache Mahout)
- GraphX for iterative graph computation and ETL (similar to Apache Giraph)

# Spark vs Hadoop MapReduce
Why has Spark gained so much momentum in the big data space - often at the expense of the tried and true Hadoop MapReduce framework?

Spark addresses and improves upon some well known shortcomings of MapReduce. While MapReduce has been a dependable and flexible foundation for big data applications during the early evolution of data science, Spark has had the advantage of learning from that existing work and has been developed to align with the state of the art.

## Better Performance
Spark often achieves 10x to 100x better performance than Hadoop MapReduce. It does especially well for iterative applications in which multiple operations are performed on the same data set.

Spark uses in-memory computations whenever possible by introducing a memory caching abstraction and only overflows results to disk when necessary. MapReduce depends on it's distributed file system (HDFS) for fault tolerance. It reads the input for each Map-Reduce step from HDFS and writes the results of each step back to the file system. Spark is able to acheive fault tolerance with it's memory cached RDDs using a restricted form of shared memory, based on coarse-grained transformations rather than fine-grained updates to shared state. In other words RDDs are immutable (read-only) and data changes are shared with other nodes by broadcasting the high level transformations that have occured to big chunks of data rather than broadcasting the individual changed values themselves.

Spark uses a distributed acyclic graph (DAG) computing model. MapReduce treats each Map-Reduce step as a separate, independent job. In applications with multiple steps Spark has a global view of of the entire computation via the DAG and can make optimizations using this additional information that MapReduce cannot.

While the DAG model and memory caching are largely responsible for Spark performance advantages, Spark also makes less fundamental but still practical improvements over MapReduce. For example, MapReduce starts up a new JVM for each Map-Reduce step on a node while Spark maintains a running executor JVM on each 
