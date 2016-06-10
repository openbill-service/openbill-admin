class VirtusSequelHstore < Virtus::Attribute
  def coerce(value)
    return '{}' unless value.present?
    return value.to_json if value.is_a? Sequel::Postgres::HStore
    value
  end
end
