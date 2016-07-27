class WebhooksFilter
  include Virtus.model

  attribute :account, Openbill::Account
end
