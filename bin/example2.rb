require 'ruby-spark'

Spark.config do
  set_app_name 'Map Reduce'
  set_master 'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

input = $sc.parallelize(0..1000)
doubled = input.map(lambda { |x| x * 2 })
summed = doubled.reduce(lambda { |sum, x| sum + x })
average = summed / input.count
puts '---- Average: ' + average.to_s

Spark.stop
