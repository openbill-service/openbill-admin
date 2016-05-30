module AccountTransactionsHelper
  def accounts_count(cat)
    Openbill.service.accounts.where(category_id: cat.id).count
  end
end
