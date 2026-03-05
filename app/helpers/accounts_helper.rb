module AccountsHelper
  def select_account_field(form, key, include_blank: false, required: false)
    selected_account_id = form.object.send(key)
    collection = accounts_collection_for_select(selected_account_id)

    form.input(
      key,
      as: :select,
      collection: collection,
      selected: selected_account_id,
      include_blank: include_blank,
      required: required
    )
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
    OpenbillAccount.ordered.map do |acc|
      account_select_item acc
    end
  end

  def accounts_collection_for_select(selected_account_id)
    collection = accounts_collection
    return collection if selected_account_id.blank?

    selected_item = collection.find { |(_, id)| id.to_s == selected_account_id.to_s }
    return collection if selected_item.present?

    selected_account = OpenbillAccount.find(selected_account_id)
    [account_select_item(selected_account), *collection]
  end

  def account_select_item(acc)
    ["#{acc.key} [#{acc.details}]", acc.id]
  end
end
