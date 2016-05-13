module AccountsHelper
  def income_transaction_button(income_account: )
    link_to t('income'), new_account_transaction_path(income_account, direction: :income), class: 'btn btn-sm btn-success'
  end

  def outcome_transaction_button(outcome_account: )
    link_to t('outcome'), new_account_transaction_path(outcome_account, direction: :outcome), class: 'btn btn-sm btn-warning'
  end
end
