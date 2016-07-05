class AccountTransaction
  delegate :id, :created_at, :revrese_transaction_id, :details, :meta, :key, :date, to: :raw_transaction

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

  def opposite_account
    @opposite_account ||= get_opposite_account
  end

  private

  attr_reader :billing_account, :raw_transaction

  def get_opposite_account
    if incoming?
      Openbill.service.get_account raw_transaction.from_account_id
    else
      Openbill.service.get_account raw_transaction.to_account_id
    end
  end
end
