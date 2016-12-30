module AccountsHelper
  def accounts_index_type_choicer
    if action_name == 'index'
      link_to 'Таблица', table_accounts_url
    else
      link_to 'Список', accounts_url
    end
  end

  def opposite_account_hint(account_id)
    return if account_id.blank? || account_id.to_s == 'total'

    account = Openbill::Account[id: account_id]

    link_to "#{account.key} (#{account.details})", account_path(account_id)
  end

  def income_transaction_button(income_account: )
    link_to fa_icon(:plus), new_account_transaction_path(income_account.id, direction: :income), class: 'btn btn-sm btn-success'
  end

  def outcome_transaction_button(outcome_account: )
    link_to fa_icon(:minus), new_account_transaction_path(outcome_account.id, direction: :outcome), class: 'btn btn-sm btn-danger'
  end

  def account_title(account)
    "#{account.category}/#{account.key} (#{account.details})"
  end

  def accounts_collection
    Openbill.service.accounts.all.map do |acc|
      account_select_item acc
    end
  end

  def account_select_item(acc)
    ["#{acc.key} [#{acc.details}]", acc.id]
  end
end
