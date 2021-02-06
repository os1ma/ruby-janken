# frozen_string_literal: true

require './app/views/cli/standard_output_view'

TEMPLATE_FILE = 'spec/views/cli/standard_output_view_sample.txt.erb'

EXPECTED = <<~TEXT
  Hello Foo
  Hello Bar
TEXT

class MyObject
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

RSpec.describe StandardOutputView do
  describe '#show' do
    it '指定したパラメータを利用したテンプレートが表示される' do # rubocop:disable RSpec/ExampleLength
      params = {
        obj1: MyObject.new('Foo'),
        obj2: MyObject.new('Bar')
      }
      expect do
        described_class.new(TEMPLATE_FILE, params).show
      end.to output(EXPECTED).to_stdout
    end
  end
end
