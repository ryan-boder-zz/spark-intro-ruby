require 'ruby-spark'

Spark.config do
  set_app_name 'Word Count'
  set_master 'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

# RDD the CSV and filter out the header
csv = $sc.text_file('data/alexa.csv').filter(lambda { |x| !x.start_with?('Date') })

# Split into columns and convert to integers
data = csv.map(lambda do |x|
  x.split(',').map { |y| y.strip.to_i }
end)

# Sum the ranks and find the most improved delta
results = data.reduce(lambda do |x, y|
  [nil, x[1] + y[1], [x[2], y[2]].min, x[3] + y[3]]
end).collect.to_a

avgGlobalRank = results[1] / csv.count
minGlobalDelta = results[2]
avgUsRank = results[3] / csv.count
puts "---- Average Global Rank: #{avgGlobalRank}, Best Global Delta: #{minGlobalDelta}, Average US Rank: #{avgUsRank}"

Spark.stop
