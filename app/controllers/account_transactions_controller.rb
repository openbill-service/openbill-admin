class AccountTransactionsController < ApplicationController
  include AccountsHelper

  def new
    render locals: {
      account: account,
      account_transaction_form: account_transaction_form,
      opposite_accounts_collection: opposite_accounts(account, direction)
    }
  end

  def create
    account_transaction_form = account_transaction_form(permitted_params)

    if account_transaction_form.valid?
      transactions.insert account_transaction_form.to_hash
      redirect_to accounts_path
    else
      render :new, locals: {
        account: account,
        account_transaction_form: account_transaction_form,
        opposite_accounts_collection: opposite_accounts(account, direction)
      }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: {
      account: account,
      account_transaction_form: account_transaction_form,
      opposite_accounts_collection: opposite_accounts(account, direction)
    }
  end

  private

  # Отдаем список аккаунтов с которыми можно делать
  # транзакцию в этом направлении согласно Policy
  def opposite_accounts(account, direction)
    case direction
    when AccountTransactionForm::INCOME_DIRECTION
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
        account_select_item acc
      end
    when AccountTransactionForm::OUTCOME_DIRECTION
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
        account_select_item acc
      end
    else
      fail "Unknown direction #{direction}"
    end
  end

  def account_transaction_form(attrs = {})
    AccountTransactionForm.new({ **attrs.symbolize_keys, account_id: account.id, amount_currency: account.amount_currency, direction: direction })
  end

  def transactions
    Openbill.service.transactions
  end

  def direction
    return params[:direction] if AccountTransactionForm::DIRECTIONS.include? params[:direction]
    fail "Unknown direction #{params[:direction]}"
  end

  def permitted_params
    params.require(:account_transaction_form).permit(
      :opposite_account_id,
      :amount_cents, :amount_currency, :key, :details, :meta)
  end

  def account
    Openbill.service.get_account_by_id params[:account_id]
  end
end
