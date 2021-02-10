# frozen_string_literal: true

# ヘルスチェック用のサービス
class HealthService
  def initialize(transaction_manager, health_query_service)
    @tm = transaction_manager
    @health_query_service = health_query_service
  end

  def healthy?
    @tm.transactional do |tx|
      @health_query_service.healthy?(tx)
    end
  end
end
