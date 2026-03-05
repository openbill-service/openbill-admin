class WebhooksFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :account
  attribute :transaction_ids, default: -> { [] }

  def transaction_ids
    Array(super).compact
  end
end
