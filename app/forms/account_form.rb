class AccountForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :meta, AccountMeta
  attribute :details, String

  def to_hash
    {
      **attributes.except(:id, :meta).select { |k, v| v.present? },
      meta: meta
    }
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
    ActiveModel::Name.new(self, nil, 'Account')
  end
end
