class AccountTransactionsController < ApplicationController
  def new
    render locals: {
      direction: direction,
      account: account,
      account_transaction_form: account_transaction_form,
      opposite_accounts_collection: opposite_accounts_collection
    }
  end

  private

  COMMON_CATEGORY = 'common'

  INCOME_DIRECTION = 'income'
  OUTCOME_DIRECTION = 'outcome'

  DIRECTIONS = [INCOME_DIRECTION, OUTCOME_DIRECTION]

  def opposite_accounts_collection
    case direction
    when INCOME_DIRECTION
      Openbill.service.accounts.where(available_outgoing: true, category: COMMON_CATEGORY)
    when OUTCOME_DIRECTION
      Openbill.service.accounts.where(available_incoming: true, category: COMMON_CATEGORY)
    else
      fail "Unknown direction #{direction}"
    end
  end

  def account_transaction_form
    AccountTransactionForm.new amount_currency: account.amount_currency
  end

  def direction
    return params[:direction] if DIRECTIONS.include? params[:direction]
    fail "Unknown direction #{params[:direction]}"
  end

  def account
    Openbill.service.get_account_by_id params[:account_id]
  end
end
