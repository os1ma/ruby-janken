# frozen_string_literal: true

# ヘルスチェックの API コントローラ
class HealthApiController
  def get
    { status: 200 }
  end
end
