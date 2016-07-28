class AccountsController < ApplicationController
  DEFAULT_CATEGORY_ID = '12832d8d-43f5-499b-82a1-3466cadcd809'

  helper_method :filter, :filter_params, :current_category

  def index
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
    filter.apply(Openbill.service.account_transactions(account).reverse_order(:created_at)).paginate(page, per_page)
  end

  def account
    @account ||= Openbill.service.get_account params[:id]
  end

  def current_category
    if session_category_id.present?
      categories[id: session_category_id]
    else
      OpenStruct.new(id: nil)
    end
  end

  def session_category_id
    if filter_set?
      session[:accounts_filter_category_id] = param_category_id
    else
      session[:accounts_filter_category_id]
    end
  end

  def param_category_id
    params[:philtre].try(:[], :category_id)
  end

  def filter_set?
    params[:philtre].present?
  end

  def default_category
    categories[id: DEFAULT_CATEGORY_ID]
  end

  def accounts
    scope = filter.apply(Openbill.service.accounts)
    scope = scope.where(category_id: current_category.id) if current_category.id.present?
    scope.paginate page, per_page
  end

  def categories
    @_categories ||= Openbill.service.categories
  end

  def permitted_params
    params.require(:account).permit(:key, :category_id, :amount_currency, :details, :meta)
  end
end
