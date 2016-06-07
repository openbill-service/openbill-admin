class CategoryForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :parent_id, Integer
  attribute :name, String

  def to_hash
    attributes.except(:id).select { |k, v| v.present? }
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
    ActiveModel::Name.new(self, nil, 'Category')
  end
end
