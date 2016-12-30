module AccountTransactionsHelper
  def amount_by_month(account, month)
    plus = Openbill.service.transactions
      .where(to_account_id: account.id)
      .where('created_at >= ? and created_at <?', month.beginning_of_month, month.end_of_month)
      .sum(:amount_cents) || 0
    minus = Openbill.service.transactions
      .where(from_account_id: account.id)
      .where('created_at >= ? and created_at <?', month.beginning_of_month, month.end_of_month)
      .sum(:amount_cents) || 0


    Money.new plus - minus, account.amount_currency
  end

  def accounts_count(cat = nil)
    if cat.present?
      Openbill.service.accounts.where(category_id: cat.id).count
    else
      Openbill.service.accounts.count
    end
  end
end
