class OpenbillWebhookLog < ApplicationRecord
  scope :ordered, -> { order 'created_at desc' }
end
