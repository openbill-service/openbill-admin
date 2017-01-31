class InvoiceForm < FormBase
  include Virtus.model

  attribute :id, String
  attribute :date, DateTime
  attribute :number, String
  attribute :title, String
  attribute :destination_account_id, String
  attribute :amount_cents, String
  attribute :amount_currency, String, default: 'RUB'

  validates :date, :number, :title, :destination_account_id, :amount_cents, :amount_currency,  presence: true

  def to_hash
    attributes.except(:id).select { |k, v| v.present? }
  end

  def to_param
    self.id
  end

  def to_model
    self
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Invoice')
  end
end
