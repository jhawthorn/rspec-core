require 'benchmark/ips'
require 'rspec/core'
require 'rspec/core/example_status_persister'

examples_txt_string = <<EOS
example_id                                                                       | status  | run_time        |
-------------------------------------------------------------------------------- | ------- | --------------- |
EOS


200.times do |a|
  10.times do |b|
    example = "./spec/test_#{a}/fake_spec[1:1:#{b}]"
    line = "%-80s | passed  | 0.12345 seconds |\n" % example
    examples_txt_string << line
  end
end

examples_txt_path = File.expand_path("../../spec/examples.txt", __FILE__)
examples_array = RSpec::Core::ExampleStatusParser.parse(examples_txt_string)

class File
  def self.exist?(filename)
    true
  end
end

Benchmark.ips do |x|
  x.report("ExampleStatusPersister#persist") do
    RSpec::Core::ExampleStatusPersister.new([], examples_txt_path).persist
  end

  x.report("ExampleStatusDumper.dump") do
    RSpec::Core::ExampleStatusDumper.dump(examples_array)
  end

  x.report("ExampleStatusMerger.merge([], all)") do
    RSpec::Core::ExampleStatusMerger.merge([], examples_array)
  end

  x.report("ExampleStatusMerger.merge(all, all)") do
    RSpec::Core::ExampleStatusMerger.merge(examples_array, examples_array)
  end

  x.report("ExampleStatusParser.parse") do
    RSpec::Core::ExampleStatusParser.parse(examples_txt_string)
  end

  #x.report("split on regex") do
  #  line.split(/\s+\|\s+?/)
  #end
  #
  #x.report("range access + rstrip") do
  #  line[0, 70].rstrip
  #  line[73, 7].rstrip
  #  line[83,15].rstrip
  #end
  #
  #x.report("range access + rstrip!") do
  #  line[0, 70].rstrip!
  #  line[73, 7].rstrip!
  #  line[83,15].rstrip!
  #end
  #
  #x.report("split on string") do
  #  line.split('|')
  #end
  #
  #x.report("split on string and strip") do
  #  line.split('|').map(&:strip)
  #end
  #
  #x.report("split on string and strip!") do
  #  line.split('|').map(&:strip!)
  #end
  #
  #x.report("split on string and rstrip") do
  #  line.split('|').map(&:rstrip)
  #end
  #
  #x.report("split on string and rstrip!") do
  #  line.split('|').map(&:rstrip!)
  #end
end
