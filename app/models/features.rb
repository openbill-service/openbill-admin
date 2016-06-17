class Features
  include Virtus.model

  attribute :has_goods, Boolean, default: false

  class << self
    delegate :has_goods?, to: :instance
  end

  def initialize
    self.has_goods = detect_has_goods?
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
end
