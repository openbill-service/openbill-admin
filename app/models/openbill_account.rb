class OpenbillAccount < ApplicationRecord
  belongs_to :category, class_name: 'OpenbillCategory'

  scope :ordered, -> { order :id }

  monetize :amount_cents

  def all_transactions
    OpenbillTransaction.by_any_account_id id
  end

  def name
    key.presence || id.to_s
  end
end
