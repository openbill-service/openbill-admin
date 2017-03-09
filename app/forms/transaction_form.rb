class TransactionForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :from_account_id, String
  attribute :to_account_id, String
  attribute :amount_cents, String
  attribute :amount_currency, String, default: 'RUB'
  attribute :reverse_transaction_id, String

  attribute :key, String
  attribute :details, String
  attribute :meta, VirtusHstore
  attribute :date, Date

  validates :from_account_id, :to_account_id,
            :amount_cents, :amount_currency,
            :key, :details, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def to_hash
    {
      **attributes.except(:id, :amount_cents, :meta, :reverse_transaction_id),
      **attributes.slice(:reverse_transaction_id).select { |k, v| v.present? },
      amount_cents: amount.cents,
      meta: meta_hstore
    }
  end

  def meta_hstore
    JSON.parse(meta)
  end

  def to_model
    self
  end

  def to_param
    id
  end

  def persisted?
    id.present?
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Transaction')
  end

  private

  def amount
    amount_cents.to_s.to_money(amount_currency)
  end
end
