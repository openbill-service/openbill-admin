class WebhooksFilter
  include Virtus.model

  attribute :account, Openbill::Account
  attribute :transaction_ids, Array[String]

  def transaction_ids
    super.compact
  end
end
