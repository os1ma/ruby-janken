# frozen_string_literal: true

# ヘルスチェックの API コントローラ
class HealthApiController
  def initialize(health_query_service)
    @health_query_service = health_query_service
  end

  def get
    status =  @health_query_service.healthy? ? 200 : 503
    { status: status }
  end
end
