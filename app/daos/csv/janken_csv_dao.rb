# frozen_string_literal: true

require 'csv'
require './app/daos/csv/csv_dao_utils'

# じゃんけんを CSV で読み書きする DAO
class JankenCsvDao
  JANKENS_CSV = "#{CsvDaoUtils::DATA_DIR}/jankens.csv"

  def insert(_, janken)
    janken_id = CsvDaoUtils.count_file_lines(JANKENS_CSV) + 1

    FileUtils.touch(JANKENS_CSV)
    CSV.open(JANKENS_CSV, 'a') do |csv|
      csv << [janken_id, janken.played_at]
    end

    Janken.new(janken_id, janken.played_at)
  end
end
