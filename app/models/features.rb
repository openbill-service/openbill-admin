class Features
  include Virtus.model

  attribute :has_goods, Boolean, default: false
  attribute :has_webhooks, Boolean, default: false

  class << self
    delegate :has_goods?, :has_webhooks?, to: :instance
  end

  def initialize
    self.has_goods = detect_has_goods?
    self.has_webhooks = detect_has_webhooks?
  end

  def self.instance
    @instance ||= new
  end

  private

  def detect_has_goods?
    defined?(Openbill::Good) && Openbill::Good.columns.is_a?(Array)
  rescue Sequel::DatabaseError
    false
  end

  def detect_has_webhooks?
    defined?(Openbill::WebhookLog) && Openbill::WebhookLog.columns.is_a?(Array)
  rescue Sequel::DatabaseError
    false
  end
end
