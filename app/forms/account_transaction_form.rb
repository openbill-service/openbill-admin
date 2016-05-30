class AccountTransactionForm < FormBase
  attribute :amount_cents, String
  attribute :amount_currency, String

  attribute :direction, String # income, outcome

  attribute :account_id, Integer
  attribute :opposite_account_id, Integer

  attribute :details, String
  attribute :key, String

  validates :amount_cents, :amount_currency, :account_id, :opposite_account_id, :details, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def amount
    return nil unless amount_cents.present?
    @_amount ||= amount_cents.to_money(amount_currency)
  end
end

