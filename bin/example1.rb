require 'ruby-spark'

Spark.config do
  set_app_name 'Counting Lines'
  set_master   'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

rdd = $sc.text_file('data/fruit.txt')

puts '---- Number of Lines: ' + rdd.count.to_s

Spark.stop
