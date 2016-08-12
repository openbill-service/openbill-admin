class AccountsController < ApplicationController
  DEFAULT_CATEGORY_ID = '12832d8d-43f5-499b-82a1-3466cadcd809'

  helper_method :filter, :filter_params, :current_category

  def index
    render locals: {
      accounts: accounts,
      categories: categories
    }
  end

  def at_date
    render locals: {
      accounts: accounts,
      categories: categories
    }
  end

  def new
    render locals: { account: AccountForm.new }
  end

  def show
    render locals: {
      account: account,
      transactions: transactions
    }
  end

  def edit
    account_form = AccountForm.new account
    render locals: { account: account_form, account_key: account.key }
  end

  def create
    account_form = AccountForm.new permitted_params

    if account_form.valid?
      accounts.insert account_form.to_hash
      redirect_to accounts_path
    else
      render :new, locals: { account: account_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { account: account_form }
  end

  def update
    account_form = AccountForm.new({ **permitted_params.symbolize_keys,
                                     id: account.id })

    if account_form.valid?
      account.update account_form.to_hash
      redirect_to accounts_path
    else
      render :edit, locals: { account_key: account.key, account: account_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { account_key: account.key, account: account_form }
  end

  def webhook_logs
    render locals: { logs: logs, db_error: @db_error }
  end

  private

  def logs
    query = WebhooksQuery.new(filter: webhooks_filter).call
    filter.apply(query).paginate page, per_page
  rescue Sequel::DatabaseError => err
    @db_error = err.message
    Bugsnag.notify err
    []
  end

  def webhooks_filter
    WebhooksFilter.new(
      account: account
    )
  end

  def ids
    account.transactions
  end

  def transactions
    transactions_philtre.apply(
      Openbill.service.account_transactions(account).reverse_order(:date)
    ).paginate(page, per_page)
  end

  def transactions_philtre
    Philtre.new philtre_params do
      def date(date)
        Sequel.lit('openbill_transactions.date <= ?', date)
      end
    end
  end

  def account
    @_account ||= find_account
  end

  def current_category
    @_current_category ||=
      if session_category_id.present?
        categories[id: session_category_id]
      else
        OpenStruct.new(id: nil)
      end
  end

  def session_category_id
    if category_filter_set?
      session[:accounts_filter_category_id] = param_category_id
    else
      session[:accounts_filter_category_id]
    end
  end

  def param_category_id
    params[:philtre][:category_id]
  end

  def category_filter_set?
    params[:philtre].try(:key?, :category_id)
  end

  def default_category
    categories[id: DEFAULT_CATEGORY_ID]
  end

  def accounts
    @_accounts ||= AccountsQuery.new(filter: accounts_filter).call
  end

  def find_account
    AccountsQuery.new(filter: account_filter).call.first!
  end

  def account_filter
    AccountsFilter.new(
      id: params[:id],
      philtre: philtre_params
    )
  end

  def accounts_filter
    AccountsFilter.new(
      category_id: current_category.id,
      page: page,
      per_page: per_page,
      philtre: philtre_params
    )
  end

  def date
    @_date ||= TransactionDate.parse params[:philtre]
  end

  def philtre_params
    params[:philtre][:date] = date if date.present?
    params[:philtre] || ActionController::Parameters.new
  end

  def categories
    @_categories ||= Openbill.service.categories
  end

  def permitted_params
    params.require(:account).permit(:key, :category_id, :amount_currency, :details, :meta)
  end
end
