class PolicyForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :from_category_id, String
  attribute :to_category_id, String
  attribute :from_account_id, String
  attribute :to_account_id, String
  attribute :name, String

  validates :name, presence: true

  def to_hash
    attributes.except(:id).map do |k, v|
      [k, v.presence || nil]
    end.to_h
  end

  def to_model
    self
  end

  def to_param
    id.to_s
  end

  def persisted?
    id.present?
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Policy')
  end
end
