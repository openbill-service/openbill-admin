class OpenbillTransaction < ApplicationRecord
  NOTIFIED_MESSAGE = 'Notified'

  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'
  has_many :webhook_logs, -> { ordered }, class_name: 'OpenbillWebhookLog'
  has_one :last_webhook_log, -> { ordered.limit 1 }, class_name: 'OpenbillWebhookLog'

  has_one :reversation_transaction, class_name: 'OpenbillTransaction', foreign_key: :reverse_transaction_id, primary_key: :id

  # Original trbansaction
  has_one :reverse_transaction, class_name: 'OpenbillTransaction', primary_key: :reverse_transaction_id, foreign_key: :id

  scope :ordered, -> { order 'created_at desc' }
  scope :by_any_account_id, -> (id) { where('from_account_id = ? or to_account_id = ?', id, id) }
  scope :by_period, -> (period) {
    scope = all
    scope = scope.where('date >= ?', period.first) if period.first.present?
    scope = scope.where('date <= ?', period.last) if period.last.present?
    scope
  }

  scope :by_month, -> (month) { by_period Range.new(month.beginning_of_month, month.end_of_month) }

  monetize :amount_cents

  def notify!
    connection.execute "notify #{self.class.table_name}", id
  end

  def self.with_pending_webhooks
    # TODO make a scope
    raise 'implement'
    #dataset
    #.select_all(:t0).distinct(:t0__id).from(Sequel.as(:openbill_transactions, :t0))
    #.left_join(
      #Sequel.as(:openbill_webhook_logs, :t1),
      #t0__id: :t1__transaction_id
    #)
    #.left_join(
      #Sequel.as(:openbill_webhook_logs, :t2),
      #[
        #t1__transaction_id: :t2__transaction_id,
        #t1__url: :t2__url,
        #t2__message: NOTIFIED_MESSAGE
      #]
    #)
    #.group(:t0__id, :t1__url)
    #.having('COUNT(t2.*) = 0')
    #.order(:t0__id, Sequel.desc(:t0__created_at))
  end
end
