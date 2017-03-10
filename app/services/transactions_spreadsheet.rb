class TransactionsSpreadsheet < Spreadsheet
  FIELDS = %w(from_account_id to_account_id date amount_cents key created_at).freeze

  def initialize(collection)
    super collection, FIELDS
  end
end
