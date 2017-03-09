class AccountTransaction
  delegate :id, :created_at, :reverse_transaction_id, :details, :meta, :key, :date, to: :raw_transaction

  def initialize(billing_account, raw_transaction)
    @billing_account = billing_account
    @raw_transaction = raw_transaction
  end

  def incoming?
    raw_transaction.to_account_id == billing_account.id
  end

  def amount
    incoming? ? raw_transaction.amount : -raw_transaction.amount
  end

  def period_date
    date || created_at.to_date
  end

  def opposite_account
    @opposite_account ||= get_opposite_account
  end

  def opposite_account_id
    opposite_account.id
  end

  private

  attr_reader :billing_account, :raw_transaction

  def get_opposite_account
    if incoming?
      raw_transaction.from_account
    else
      raw_transaction.to_account
    end
  end
end
