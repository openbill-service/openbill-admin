class AccountTransactionForm < FormBase
  INCOME_DIRECTION = 'income'
  OUTCOME_DIRECTION = 'outcome'

  DIRECTIONS = [INCOME_DIRECTION, OUTCOME_DIRECTION]

  attribute :amount_cents, :string
  attribute :amount_currency, :string

  attribute :direction, :string # income, outcome

  attribute :account_id, :integer
  attribute :opposite_account_id, :integer

  attribute :details, :string
  attribute :key, :string
  attribute :meta, :string
  attribute :date, :date

  validates :amount_cents, :amount_currency, :account_id, :opposite_account_id, :details, :key, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :direction, inclusion: { in: DIRECTIONS }

  def to_hash
    attrs = attributes.symbolize_keys

    {
      **attrs.slice(:amount_currency, :details, :key),
      **attrs.slice(:date).select { |_, value| value.present? },
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
    parse_json_object(meta, field_name: "meta")
  end
end
