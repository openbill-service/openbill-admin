class AccountsController < ApplicationController
  DEFAULT_CATEGORY_ID = '12832d8d-43f5-499b-82a1-3466cadcd809'

  helper_method :filter, :filter_params, :current_category

  def index
    months = [Date.today.end_of_month]
    5.times do
      months.unshift (months.first.beginning_of_month - 1.day).end_of_month
    end
    render locals: {
      months: months,
      accounts: accounts,
      categories: categories,
      ransack: ransack,
      current_category: current_category,
    }
  end

  def suggestions
    accounts = OpenbillAccount.ordered.where("key like ?", "#{params[:q]}%")
    render json: {
      total_count: accounts.count,
      items: accounts.map { |c| { id: c.id, text: "#{c.name} (#{c.details})" }}
    }
  end

  def at_date
    render locals: {
      accounts: accounts,
      categories: categories
    }
  end

  def new
    render locals: { account: OpenbillAccount.new }
  end

  def show
    transactions_ransack = account.all_transactions.ransack params[:q]

    transactions = transactions_ransack.result.ordered.page(page).per(per_page)
    render locals: {
      account: account,
      transactions_ransack: transactions_ransack,
      transactions: transactions
    }
  end

  def edit
    render locals: { account: account, account_key: account.key }
  end

  def create
    account = OpenbillAccount.new permitted_params

    if account.save
      redirect_to accounts_path
    else
      render :new, locals: { account: account }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { account: account }
  end

  def update
    account.update permitted_params

    if account.valid?
      redirect_to accounts_path
    else
      render :edit, locals: { account_key: account.key, account: account }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { account_key: account.key, account: account }
  end

  def webhook_logs
    render locals: { logs: logs, db_error: @db_error }
  end

  private

  def logs
    query = WebhooksQuery.new(filter: webhooks_filter).call
    filter.apply(query).paginate page, per_page
  end

  def webhooks_filter
    WebhooksFilter.new(
      account: account
    )
  end

  def ransack
    OpenbillAccount.ransack params[:q]
  end

  def accounts
    ransack.result.ordered
  end

  def account
    @_account ||= OpenbillAccount.find params[:id]
  end

  def current_category
    id  =params.fetch(:q, {})[:category_id_eq]
    return unless  id
    OpenbillCategory.find id
  end

  def categories
    @_categories ||= OpenbillCategory.all
  end

  def permitted_params
    params.require(:account).permit(:key, :category_id, :amount_currency, :details, :meta)
  end
end
