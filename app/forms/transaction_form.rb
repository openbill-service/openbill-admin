class TransactionForm < FormBase
  include Virtus.model

  attribute :username, String
  attribute :from_account_id, String
  attribute :to_account_id, String
  attribute :amount_cents, String
  attribute :amount_currency, String, default: 'RUB'
  attribute :key, String
  attribute :details, String
  attribute :meta, VirtusSequelHstore

  validates :username,
            :from_account_id, :to_account_id,
            :amount_cents, :amount_currency,
            :key, :details, presence: true

  def to_hash
    {
      **attributes.except(:amount_cents, :meta),
      amount_cents: amount.cents,
      meta: meta_hstore
    }
  end

  def amount
    amount_cents.to_s.to_money(amount_currency)
  end

  def meta_hstore
    Sequel::Postgres::HStore.new JSON.parse(meta)
  end

  def to_model
    self
  end

  def persisted?
    false
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Transaction')
  end
end
