class WebhooksQuery
  include Virtus.model

  attribute :filter, WebhooksFilter, default: WebhooksFilter.new

  def call
    scope = basic_scope
    scope = filter_by_account scope if filter.account.present?
    scope = order scope
    scope
  end

  private

  def filter_by_account(scope)
    scope.join(:openbill_transactions, id: :transaction_id)
    .where(
      Sequel.or(
        openbill_transactions__from_account_id: filter.account.id,
        openbill_transactions__to_account_id: filter.account.id
      )
    )
  end

  def order(scope)
    scope.reverse_order(:openbill_webhook_logs__created_at)
  end

  def basic_scope
    Openbill.service.webhook_logs
  end
end
