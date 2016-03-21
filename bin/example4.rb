require 'ruby-spark'

Spark.config do
  set_app_name 'Word Count'
  set_master 'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

text_file = $sc.text_file('data/atlas.txt')
words = text_file.flat_map(lambda { |x| x.split(/[\s.,!?"']+/) })
pairs = words.map(lambda { |word| [word.downcase, 1] })
counts = pairs.reduce_by_key(lambda { |a, b| a + b })
results = counts.sort_by(lambda { |x| x[1] }, false).collect

# Ruby-Spark seems to be missing the RDD.save_as_text_file method
File.open('example4-output.txt', 'w') do |file|
  results.each { |x| file.puts(x[0] + ': ' + x[1].to_s) unless x[0].empty? }
end

Spark.stop
