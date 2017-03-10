class OpenbillTransaction < ApplicationRecord
  NOTIFIED_MESSAGE = 'Notified'

  belongs_to :from_account, class: 'Openbill::Account'
  belongs_to :to_account, class: 'Openbill::Account'
  belongs_to :good, class: 'Openbill::Good'
  has_many :webhook_logs, class: 'Openbill::WebhookLog' #, order: :created_at
  has_one :last_webhook_log, class: 'Openbill::WebhookLog' #, order: Sequel.desc(:created_at), limit: 1

  has_one :reversation_transaction, class: 'Openbill::Transaction', key: :reverse_transaction_id, primary_key: :id

  # Original transaction
  has_one :reverse_transaction, class: 'Openbill::Transaction', primary_key: :reverse_transaction_id, key: :id

  def self.with_pending_webhooks
    dataset
      .select_all(:t0).distinct(:t0__id).from(Sequel.as(:openbill_transactions, :t0))
      .left_join(
    Sequel.as(:openbill_webhook_logs, :t1),
    t0__id: :t1__transaction_id
    )
      .left_join(
    Sequel.as(:openbill_webhook_logs, :t2),
    [
      t1__transaction_id: :t2__transaction_id,
      t1__url: :t2__url,
      t2__message: NOTIFIED_MESSAGE
    ]
    )
      .group(:t0__id, :t1__url)
      .having('COUNT(t2.*) = 0')
      .order(:t0__id, Sequel.desc(:t0__created_at))
  end

  def <=> (other)
    id <=> other.id
  end

  def amount
    Money.new amount_cents, amount_currency
  end
end
