class GoodForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :group_id, String
  attribute :title, String
  attribute :unit, String
  attribute :details, String
  attribute :meta, VirtusSequelHstore

  validates :title, :unit, presence: true

  def to_hash
    {
      **attributes.except(:id, :meta).select { |k, v| v.present? },
      meta: meta_hstore
    }
  end

  def meta_hstore
    Sequel::Postgres::HStore.new JSON.parse(meta)
  end

  def to_model
    self
  end

  def to_param
    id
  end

  def persisted?
    id.present?
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Good')
  end
end
