class AccountsFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :category_id, :string
  attribute :page, :integer, default: 1
  attribute :per_page, :integer, default: 10
  attribute :philtre, default: -> { {} }

  def date
    philtre.to_h["date"]
  end
end
