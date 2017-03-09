module AccountTransactionsHelper
  def amount_by_month(account, month)
    plus = OpenbillTransaction
      .where(to_account_id: account.id)
      .where('date >= ? and date <= ?', month.beginning_of_month, month.end_of_month)
      .sum(:amount_cents) || 0
    minus = OpenbillTransaction
      .where(from_account_id: account.id)
      .where('date >= ? and date <= ?', month.beginning_of_month, month.end_of_month)
      .sum(:amount_cents) || 0


    Money.new plus - minus, account.amount_currency
  end

  def accounts_count(cat = nil)
    if cat.present?
      OpenbillAccount.where(category_id: cat.id).count
    else
      OpenbillAccount.count
    end
  end
end
