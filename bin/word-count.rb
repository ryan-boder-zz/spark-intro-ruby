require 'ruby-spark'

if ARGV.length != 2
  puts 'Usage: <input file> <output file>'
  exit
end


Spark.config do
  set_app_name 'Word Count'
  set_master   'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc


text_file = $sc.text_file(ARGV[0])


words = text_file.flat_map(lambda{ |x| x.split(/[\s.,!?"']+/) })

pairs = words.map(lambda{ |word| [word.downcase, 1] })

counts = pairs.reduce_by_key(lambda{ |a, b| a + b })

results = counts.sort_by(lambda{ |x| x[1] }, false).collect


File.open(ARGV[1], 'w') do |file|
  results.each { |x| file.puts(x[0] + ': ' + x[1].to_s) unless x[0].empty? }
end


Spark.stop
