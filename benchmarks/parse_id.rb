require 'benchmark/ips'
require 'rspec/core'

id = "./spec/testing/fake_spec.rb[1:2:12]"

Benchmark.ips do |x|
  x.report "Example.parse_id" do
    ::RSpec::Core::Example.parse_id(id)
  end

  x.report "id.match.captures" do
    id.match(/\A(.*?)(?:\[([\d\s:,]+)\])?\z/).captures
  end

  x.report "id =~, id[]" do
    offset = (id =~ /\[([\d\s:,]+)\]\z/)
    [id[0,offset], $1]
  end

  x.report "id =~, $`" do
    if (id =~ /\[([\d\s:,]+)\]\z/)
      [$`, $1]
    else
      [id, nil]
    end
  end

  # Not actually a replacement because it fails when filename has a [ and
  # doesn't extract example ids.
  x.report "id[id.index]" do
    id[0, id.index("[")]
  end
end
