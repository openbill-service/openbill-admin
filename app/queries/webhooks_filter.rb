class WebhooksFilter
  include Virtus.model

  attribute :account, OpenbillAccount
  attribute :transaction_ids, Array[String]

  def transaction_ids
    super.compact
  end
end
