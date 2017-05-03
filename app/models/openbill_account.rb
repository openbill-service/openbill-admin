class OpenbillAccount < ApplicationRecord
  belongs_to :category, class_name: 'OpenbillCategory'

  has_many :income_transactions, class_name: 'OpenbillTransaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'OpenbillTransaction', foreign_key: :from_account_id

  scope :ordered, -> { order :key }

  monetize :amount_cents

  def amount_by_period(period)
    sql =  ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT openbill_period_amount(?, ?, ?) FROM openbill_accounts WHERE id=?", id, period.first, period.last, id])
    value = OpenbillAccount.connection.select_value sql
    return unless value
    Money.new value, amount_currency
  end

  def all_transactions
    OpenbillTransaction.by_any_account_id id
  end

  def name
    key.presence || id.to_s
  end

  def url
    meta['url']
  end
end
