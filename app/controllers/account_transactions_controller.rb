class AccountTransactionsController < ApplicationController
  include AccountsHelper
  helper_method :filter

  def index
    render locals: {
      account: account,
      transactions: transactions
    }
  end

  def new
    render locals: {
      account: account,
      account_transaction_form: build_account_transaction_form(permitted_params),
      opposite_accounts_collection: opposite_accounts(account, direction),
      example_transactions: example_transactions
    }
  end

  def create
    account_transaction_form = build_account_transaction_form(permitted_params)

    if account_transaction_form.valid?
      OpenbillTransaction.create! account_transaction_form.to_hash
      redirect_to account_path(account.id)
    else
      render :new, locals: {
        account: account,
        account_transaction_form: account_transaction_form,
        opposite_accounts_collection: opposite_accounts(account, direction),
        example_transactions: example_transactions
      }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: {
      account: account,
      account_transaction_form: account_transaction_form,
      opposite_accounts_collection: opposite_accounts(account, direction),
      example_transactions: example_transactions
    }
  end

  private

  # Отдаем список аккаунтов с которыми можно делать
  # транзакцию в этом направлении согласно Policy
  def opposite_accounts(account, direction)
    accounts_repository
      .opposite_accounts_for(account: account, direction: direction)
      .map { |acc| account_select_item(acc) }
  end

  def build_account_transaction_form(attrs = {})
    AccountTransactionForm.new({
      **attrs.symbolize_keys,
      account_id: account.id,
      amount_currency: account.amount_currency,
      direction: direction
    })
  end

  def example_transactions
    case params[:direction]
    when AccountTransactionForm::INCOME_DIRECTION
      scope = account.income_transactions
    when AccountTransactionForm::OUTCOME_DIRECTION
      scope = account.outcome_transactions
    else
      scope = account.all_transactions
    end
    scope = account.all_transactions

    scope.ordered.first(5)
  end

  #def date
    #return unless params.key?(:account_transaction_form)
    #TransactionDate.parse permitted_params
  #end

  def transactions
    res = filter
      .apply( account.all_transactions.reverse_order(:created_at) )

    res
      .paginate(page, per_page)
  end

  def direction
    return params[:direction] if AccountTransactionForm::DIRECTIONS.include? params[:direction]
    fail "Unknown direction #{params[:direction]}"
  end

  def permitted_params
    params.fetch(:account_transaction_form, {}).permit(
      :opposite_account_id,
      :amount_cents, :amount_currency, :key, :details, :meta, :date)
  end

  def account
    @_account ||= OpenbillAccount.find params[:account_id]
  end

  def filter
    Philtre.new filter_params do
      def opposite_account_id(id)
        return true if id == 'total'
        Sequel.expr(from_account_id: id) | Sequel.expr(to_account_id: id)
      end

      def month(date)
        return true if date == 'total'
        (Sequel.expr(:date) >= Date.parse(date).beginning_of_month) & (Sequel.expr(:date) <= Date.parse(date).end_of_month)
      end
    end
  end

  def accounts_repository
    @_accounts_repository ||= OpenbillCore::AccountsRepository.new
  end
end
