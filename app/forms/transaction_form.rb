class TransactionForm < FormBase
  include Virtus.model

  attribute :from_account_id, String
  attribute :to_account_id, String
  attribute :amount_cents, String
  attribute :amount_currency, String, default: 'RUB'

  if Features.has_goods?
    attribute :good_id, String
    attribute :good_value, Integer
    attribute :good_unit, String
    validates :good_value, numericality: { greater_than: 0 }, if: 'good_id.present?'
    validates :good_unit, presence: true, if: 'good_id.present?'
  end

  attribute :key, String
  attribute :details, String
  attribute :meta, VirtusSequelHstore
  attribute :date, Date

  validates :from_account_id, :to_account_id,
            :amount_cents, :amount_currency,
            :key, :details, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def to_hash
    {
      **attributes.except(:amount_cents, :meta, :good_id, :good_value, :good_unit),
      **attributes.slice(:good_id, :good_value, :good_unit).select { |k, v| v.present? },
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
