class AccountMeta < Virtus::Attribute
  def coerce(value)
    return Sequel::Postgres::HStore.new({}) unless value.present?
    return value.to_json if value.is_a? Sequel::Postgres::HStore

    Sequel::Postgres::HStore.new JSON.parse(value)
  end
end
