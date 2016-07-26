class AccountReportsController < ApplicationController
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

      key = { month: month, opposite_account_id: t.opposite_account_id }
      opposite_accounts << t.opposite_account

      a = data[key] ||= { amount: 0 }
      a[:amount] += t.amount
    end

    return OpenStruct.new data: data, months: months, opposite_accounts: opposite_accounts
  end

  def account
    @_account ||= Openbill.service.get_account_by_id params[:account_id]
  end
end

