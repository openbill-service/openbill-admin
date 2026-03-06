module OpenbillCore
  class Contract
    Error = Class.new(StandardError)

    REQUIRED_TABLE_COLUMNS = {
      openbill_accounts: %w[id category_id key amount_cents amount_currency created_at],
      openbill_categories: %w[id name],
      openbill_transactions: %w[id from_account_id to_account_id amount_cents amount_currency key details created_at],
      openbill_policies: %w[id name from_category_id to_category_id from_account_id to_account_id],
      openbill_invoices: %w[id date number title destination_account_id amount_cents amount_currency]
    }.freeze

    def verify!(connection: ApplicationRecord.connection)
      missing_tables = REQUIRED_TABLE_COLUMNS.keys.reject { |table| connection.data_source_exists?(table.to_s) }
      raise Error, "Missing openbill-core tables: #{missing_tables.join(', ')}" if missing_tables.any?

      missing_columns = REQUIRED_TABLE_COLUMNS.each_with_object({}) do |(table, columns), result|
        existing_columns = connection.columns(table).map(&:name)
        diff = columns - existing_columns
        result[table] = diff if diff.any?
      end

      if missing_columns.any?
        message = missing_columns.map { |table, columns| "#{table}(#{columns.join(', ')})" }.join(', ')
        raise Error, "Missing openbill-core columns: #{message}"
      end

      true
    end
  end
end
