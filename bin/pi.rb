require 'ruby-spark'

if ARGV.length != 1
  puts 'Usage: <n>'
  exit
end

Spark.config do
  set_app_name 'Estimate Pi'
  set_master 'local[*]'
  set 'spark.ruby.serializer', 'marshal'
  set 'spark.ruby.serializer.batch_size', 2048
end

Spark.start
$sc = Spark.sc

n = ARGV[0].to_i
hits = $sc.parallelize(1..n).map(lambda do |_|
  x = rand * 2 - 1
  y = rand * 2 - 1
  x**2 + y**2 < 1 ? 1 : 0
end).sum
pi = 4.0 * hits / n
puts "---- Pi ~ #{pi} in #{n} simulations"

Spark.stop
