class OpenbillInvoice < ApplicationRecord
  belongs_to :destination_account, class_name: 'OpenbillAccount'

  monetize :amount_cents
end
