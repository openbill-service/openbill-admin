class OpenbillCategory < ApplicationRecord
  has_many :accounts, class_name: 'OpenbillAccount'

  def self.date
    # Sequel.lit('openbill_transactions.date <= ?', date)
  end
end
