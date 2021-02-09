# frozen_string_literal: true

# ヘルスチェックの API コントローラ
class HealthApiController
  def index
    { status: 200 }
  end
end
