module AccountsHelper
  def select_account_field(form, key, include_blank: false)
    form.input key, as: :select, collection: accounts_selected_collection(form.object.send(key)), include_blank: include_blank, input_html: { data: { accounts: true }}
  end

  def accounts_selected_collection(account_id)
    return [] unless account_id
    account = OpenbillAccount.find account_id
    [account]
  end

  def opposite_account_hint(account_id)
    return if account_id.blank? || account_id.to_s == 'total'

    account = OpenbillAccount.find account_id

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
    OpenbillAccount.find_each.map do |acc|
      account_select_item acc
    end
  end

  def account_select_item(acc)
    ["#{acc.key} [#{acc.details}]", acc.id]
  end
end
