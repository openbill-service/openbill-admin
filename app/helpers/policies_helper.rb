module PoliciesHelper
  def policy_categories_collection
    Openbill.service.categories.all.map do |category|
      [category.name, category.id]
    end
  end

  def policy_accounts_collection
    Openbill.service.accounts.all.map do |acc|
      account_select_item acc
    end
  end
end
