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

    def insert_all_and_return_object_with_keys(conn, mapper, table_name, objects)
      return [] if objects.empty?

      column_names = get_sorted_column_names(mapper, objects)
      sql = build_insert_sql(table_name, column_names, objects.size)

      params = objects.map { |o| mapper.object_to_insert_params(o) }
                      .flat_map do |hash|
                        hash.keys.sort.map { |key| hash[key] }
                      end

      conn.prepare(sql, sql)
      res = conn.exec_prepared(sql, params)

      result_to_object_with_ids(mapper, res, objects)
    end

    def insert_one_and_return_object_with_key(conn, mapper, table_name, object)
      insert_all_and_return_object_with_keys(conn, mapper, table_name, [object]).first
    end

    private

    def result_to_object_with_ids(mapper, result, object_without_ids)
      result.map.with_index do |row, i|
        id = row['id']
        mapper.map_with_id(id, object_without_ids[i])
      end
    end

    def get_sorted_column_names(mapper, objects)
      mapper.object_to_insert_params(objects[0]).keys.sort
    end

    def build_insert_sql(table_name, column_names, row_count)
      column_names_str = build_column_names_str(column_names)
      insert_values_str = build_insert_values_str(column_names, row_count)

      format(
        'INSERT INTO "%<table_name>s" %<column_names_str>s VALUES %<insert_values_str>s RETURNING "id"',
        table_name: table_name,
        column_names_str: column_names_str,
        insert_values_str: insert_values_str
      )
    end

    # ("column1", "column2", ...) のという文字列を作成
    def build_column_names_str(column_names)
      '(' + column_names.map { |c| '"' + c.to_s + '"' }.join(', ') + ')' # rubocop:disable Style/StringConcatenation
    end

    # ($1, $2, ...), ($3, $4, ...), ... という文字列を作成
    def build_insert_values_str(column_names, row_count)
      column_count = column_names.size
      (0...row_count).map do |i|
        offset = i * column_count
        # ($1, $2, ...) という文字列を作成
        '(' + (0...column_count).map { |j| '$' + (offset + j + 1).to_s }.join(', ') + ')' # rubocop:disable Style/StringConcatenation
      end.join(', ')
    end
  end
end
