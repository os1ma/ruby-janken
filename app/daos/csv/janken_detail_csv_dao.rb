# frozen_string_literal: true

require 'csv'
require './app/daos/csv/csv_dao_utils'

# じゃんけん明細を CSV で読み書きする DAO
class JankenDetailCsvDao
  JANKEN_DETAILS_CSV = "#{CsvDaoUtils::DATA_DIR}/janken_details.csv"

  def insert_all(janken_details) # rubocop:disable Metrics/AbcSize
    FileUtils.touch(JANKEN_DETAILS_CSV)

    max_janken_detail_id_before_insert = CsvDaoUtils.count_file_lines(JANKEN_DETAILS_CSV)

    CSV.open(JANKEN_DETAILS_CSV, 'a') do |csv|
      janken_details.map.with_index do |jd, index|
        janken_detail_id = max_janken_detail_id_before_insert + index + 1
        csv << [janken_detail_id, jd.janken_id, jd.player_id, jd.hand.number, jd.result.number]
        JankenDetail.new(janken_detail_id, jd.janken_id, jd.player_id, jd.hand, jd.result)
      end
    end
  end
end
