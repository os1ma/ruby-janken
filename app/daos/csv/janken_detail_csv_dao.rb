# frozen_string_literal: true

require 'csv'
require './app/daos/csv/csv_dao_utils'

# じゃんけん明細を CSV で読み書きする DAO
class JankenDetailCsvDao
  JANKEN_DETAILS_CSV = "#{CsvDaoUtils::DATA_DIR}/janken_details.csv"

  def insert_all(janken_details)
    FileUtils.touch(JANKEN_DETAILS_CSV)

    starting_id = CsvDaoUtils.count_file_lines(JANKEN_DETAILS_CSV) + 1

    CSV.open(JANKEN_DETAILS_CSV, 'a') do |csv|
      insert_all_with_starting_id(janken_details, starting_id, csv)
    end
  end

  private

  def insert_all_with_starting_id(janken_details, starting_id, csv)
    janken_details.map.with_index do |jd, index|
      janken_detail_id = starting_id + index
      csv << [janken_detail_id, jd.janken_id, jd.player_id, jd.hand.number, jd.result.number]
      JankenDetail.new(janken_detail_id, jd.janken_id, jd.player_id, jd.hand, jd.result)
    end
  end
end
