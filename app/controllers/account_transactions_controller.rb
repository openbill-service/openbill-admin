class AccountTransactionsController < ApplicationController
  def new
    render locals: {
      direction: direction,
      account: account,
      account_transaction_form: account_transaction_form,
      opposite_accounts_collection: opposite_accounts(account, direction)
    }
  end

  private

  COMMON_CATEGORY = 'common'

  INCOME_DIRECTION = 'income'
  OUTCOME_DIRECTION = 'outcome'

  DIRECTIONS = [INCOME_DIRECTION, OUTCOME_DIRECTION]

  # Отдаем список аккаунтов с которыми можно делать
  # транзакцию в этом направлении согласно Policy
  def opposite_accounts(account, direction)
    case direction
    when INCOME_DIRECTION
      # Ищем все аккаунты с которых можно перечислять на данный
      policies = Openbill.service.policies.where('(to_account_id = ? or to_account_id is null) and (to_category_id = ? or to_category_id is null)', account.id, account.category_id);
      where = policies.map do |policy|
        account_id = policy.from_account_id
        category_id = policy.from_category_id

        queries = []
        queries.push "id = '#{account_id}'" unless account_id.nil?
        queries.push "category_id = '#{category_id}'" unless category_id.nil?
        queries.join(' and ')
      end.join(' or ')

      return [] if where.blank?
      Openbill.service.accounts.where(where).all.map do |acc|
        ["#{acc.key} [#{acc.details}]", acc.id]
      end
    when OUTCOME_DIRECTION
      policies = Openbill.service.policies.where('(from_account_id = ? or from_account_id is null) and (from_category_id = ? or from_category_id is null)', account.id, account.category_id);
      where = policies.map do |policy|
        account_id = policy.to_account_id
        category_id = policy.to_category_id

        queries = []
        queries.push "id = '#{account_id}'" unless account_id.nil?
        queries.push "category_id = '#{category_id}'" unless category_id.nil?
        queries.join(' and ')
      end.join(' or ')

      return [] if where.blank?
      Openbill.service.accounts.where(where).all.map do |acc|
        ["#{acc.key} [#{acc.details}]", acc.id]
      end
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
