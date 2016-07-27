class AccountReportsController < ApplicationController
  helper_method :account

  def index
    render locals: {
      account: account,
      report: generate_monthly_report,
    }
  end

  private

  def generate_monthly_report
    months = Set.new
    opposite_accounts = Set.new

    data = {}

    Openbill
      .service
      .account_transactions(account)
      .each do |t|

      t = AccountTransaction.new account, t

      month = t.period_date.end_of_month
      months << month

      opposite_accounts << t.opposite_account

      add_transaction data, t, month: month, opposite_account_id: t.opposite_account_id
      add_transaction data, t, month: month, opposite_account_id: :total
      add_transaction data, t, month: :total, opposite_account_id: t.opposite_account_id
      add_transaction data, t, month: :total, opposite_account_id: :total
    end

    return OpenStruct.new data: data, months: months, columns: [*months.sort, :total], opposite_accounts: opposite_accounts
  end


  def add_transaction(data, t, key = {})
    a = data[key] ||= { amount: 0, net_amount: 0, margin_amount: 0 }
    a[:amount] += t.amount
    if t.amount > 0
      a[:margin_amount] += t.amount
    else
      a[:net_amount] += t.amount
    end
  end

  def account
    @_account ||= Openbill.service.get_account_by_id params[:account_id]
  end
end

