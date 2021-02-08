# frozen_string_literal: true

# ダミーのトランザクション管理を提供するモジュール
module DummyTransactionManager
  class << self
    def transactional
      yield
    end
  end
end
