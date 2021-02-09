# frozen_string_literal: true

# じゃんけんリポジトリ
class JankenRepository
  def initialize(janken_dao, janken_detail_dao)
    @janken_dao = janken_dao
    @janken_detail_dao = janken_detail_dao
  end

  def save(transaction, janken)
    janken_id = @janken_dao.insert(transaction, janken).id
    janken_details_with_janken_id = janken.details.map do |jd|
      JankenDetail.new(nil, janken_id, jd.player_id, jd.hand, jd.result)
    end
    @janken_detail_dao.insert_all(transaction, janken_details_with_janken_id)
  end
end
