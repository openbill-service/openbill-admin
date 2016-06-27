module AccountTransactionsHelper
  def accounts_count(cat = nil)
    if cat.present?
      Openbill.service.accounts.where(category_id: cat.id).count
    else
      Openbill.service.accounts.count
    end
  end
end
