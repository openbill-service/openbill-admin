module AccountTransactionsHelper
  def accounts_count(cat = nil)
    if cat.present?
      OpenbillAccount.where(category_id: cat.id).count
    else
      OpenbillAccount.count
    end
  end
end
