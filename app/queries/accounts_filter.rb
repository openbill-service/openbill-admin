class AccountsFilter
  include Virtus.model

  attribute :id, String
  attribute :category_id, String
  attribute :page, Integer, default: 1
  attribute :per_page, Integer, default: 10
  attribute :philtre, Hash

  def date
    philtre['date']
  end
end
