require 'csv'

class TransactionsSpreadsheet
  attr_reader :collection
  FIELDS = %w(from_account_id to_account_id date amount_cents key created_at).freeze

  def initialize(collection)
    @collection = collection
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << FIELDS
      collection.each do |t|
        csv << row(t)
      end
    end
  end

  private

  def row(t)
    FIELDS.map{ |f| t.send(f) }
  end
end
