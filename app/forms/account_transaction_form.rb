class AccountTransactionForm < FormBase
  INCOME_DIRECTION = 'income'
  OUTCOME_DIRECTION = 'outcome'

  DIRECTIONS = [INCOME_DIRECTION, OUTCOME_DIRECTION]

  attribute :amount_cents, String
  attribute :amount_currency, String

  attribute :direction, String # income, outcome

  attribute :account_id, Integer
  attribute :opposite_account_id, Integer

  attribute :details, String
  attribute :key, String
  attribute :meta, VirtusSequelHstore
  attribute :date, Date

  if Features.has_goods?
    attribute :good_id, String
    attribute :good_value, Integer
    attribute :good_unit, String
    validates :good_value, numericality: { greater_than: 0 }, if: 'good_id.present?'
    validates :good_unit, presence: true, if: 'good_id.present?'
  end

  validates :amount_cents, :amount_currency, :account_id, :opposite_account_id, :details, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :direction, inclusion: { in: DIRECTIONS }

  def to_hash
    {
      **attributes.slice(:amount_currency, :details, :key, :good_id, :good_value, :good_unit),
      **attributes.slice(:good_id, :good_value, :good_unit, :date).select { |k, v| v.present? },
      from_account_id: from_account_id,
      to_account_id: to_account_id,
      amount_cents: amount.cents,
      meta: meta_hstore,
    }
  end

  def from_account_id
    direction == INCOME_DIRECTION ? opposite_account_id : account_id
  end

  def to_account_id
    direction == INCOME_DIRECTION ? account_id : opposite_account_id
  end

  def amount
    amount_cents.to_s.to_money(amount_currency)
  end

  def meta_hstore
    Sequel::Postgres::HStore.new JSON.parse(meta)
  end
end
