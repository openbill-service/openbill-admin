class OpenbillWebhookLog < ApplicationRecord
  scope :ordered, -> { order 'id desc' }
end
