module PoliciesHelper
  def policy_accounts_collection
    Openbill.service.accounts.all.map do |acc|
      account_select_item acc
    end
  end
end
