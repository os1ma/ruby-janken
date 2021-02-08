# frozen_string_literal: true

# pg のラッパーモジュール
module PgWrapper
  COUNT_QUERY = 'SELECT COUNT(*) AS "count_value" FROM %s'

  class << self
    def find(conn, mapper, sql, params)
      conn.prepare(sql, sql)
      res = conn.exec_prepared(sql, params)
      res.map { |r| mapper.map(r) }
    end

    def find_first(conn, mapper, sql, params)
      find(conn, mapper, sql, params).first
    end

    def count(conn, table_name)
      query = format(COUNT_QUERY, table_name)
      res = conn.exec(query)
      res[0]['count_value'].to_i
    end
  end
end
