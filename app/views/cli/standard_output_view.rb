# frozen_string_literal: true

require 'erb'

# 標準出力に表示するビュー
class StandardOutputView
  def initialize(template, params = {})
    @template = template
    @params = params
  end

  def show
    template_str = File.open(@template, 'r').readlines.join
    puts ERB.new(template_str, trim_mode: '<>').result_with_hash(@params)
  end
end
