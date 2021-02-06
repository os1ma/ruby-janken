# frozen_string_literal: true

require 'csv'

# CSV の DAO に関するユーティリティ
module CsvDaoUtils
  DATA_DIR = './data'

  class << self
    def count_file_lines(file_name)
      File.open(file_name, 'r') do |file|
        file.readlines.size
      end
    end
  end
end
