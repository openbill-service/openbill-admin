class TransactionForm < FormBase
  attribute :id, :string
  attribute :from_account_id, :string
  attribute :to_account_id, :string
  attribute :amount_cents, :string
  attribute :amount_currency, :string, default: "RUB"
  attribute :reverse_transaction_id, :string

  attribute :key, :string
  attribute :details, :string
  attribute :meta, :string
  attribute :date, :date

  validates :from_account_id, :to_account_id,
            :amount_cents, :amount_currency,
            :key, :details, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def to_hash
    attrs = attributes.symbolize_keys

    {
      **attrs.except(:id, :amount_cents, :meta, :reverse_transaction_id),
      **attrs.slice(:reverse_transaction_id).select { |_, value| value.present? },
      amount_cents: amount.cents,
      meta: meta_hstore
    }
  end

  def meta_hstore
    parse_json_object(meta, field_name: "meta")
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
