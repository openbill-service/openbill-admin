class AccountsController < ApplicationController
  DEFAULT_CATEGORY_ID = '12832d8d-43f5-499b-82a1-3466cadcd809'

  MONTHS_TO_SHOW_COUNT = 5

  helper_method :filter, :filter_params, :current_category

  def index
    respond_to do |format|
      format.html {
        render locals: {
          periods: build_periods,
          accounts: accounts,
          categories: categories,
          ransack: ransack,
          current_category: current_category,
        }
      }
      format.csv {
        content = AccountsSpreadsheet.new(accounts, build_periods).to_csv
        send_data(
            content,
            disposition: 'attachment; filename=accounts.csv',
            type: 'text/csv'
        )
      }
    end
  end

  def suggestions
    accounts = OpenbillAccount.order(:key).where("key like ?", "#{params[:q]}%")
    render json: {
      total_count: accounts.count,
      items: accounts.map { |c| { id: c.id, text: "#{c.name} (#{c.details})" }}
    }
  end

  def at_date
    render locals: {
      accounts: accounts,
      ransack: ransack,
      current_category: current_category,
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
    all_accounts.page(page).per(per_page)
  end

  def all_accounts
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

  def start_date
    OpenbillTransaction.order('created_at asc').first.try(:created_at).try(:date) || Date.today
  end

  def build_periods
    today = Date.today
    periods = [Period.new(today.beginning_of_month, today.end_of_month)]
    MONTHS_TO_SHOW_COUNT.times do
      period = periods.last
      first = (period.first - 1.day).beginning_of_month
      last = first.end_of_month
      periods.push Period.new(first, last)
    end

    period = periods.last.last
    periods.push Period.new(nil, (period.beginning_of_month - 1.day).end_of_month)

    periods.reverse
  end
end
