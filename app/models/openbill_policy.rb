class OpenbillPolicy < ApplicationRecord
  belongs_to :from_category, class_name: 'OpenbillCategory'
  belongs_to :to_category, class_name: 'OpenbillCategory'
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'
end
