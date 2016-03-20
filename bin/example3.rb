require 'ruby-spark'

Spark.config do
  set_app_name 'Word Count'
  set_master 'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

text_file = $sc.text_file('data/fruit.txt')
words = text_file.flat_map(lambda { |x| x.split() })
pairs = words.map(lambda { |word| [word, 1] })
counts = pairs.reduce_by_key(lambda { |a, b| a + b })
puts '---- Word Counts: ' + counts.collect.to_s

Spark.stop
