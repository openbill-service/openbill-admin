begin
  Openbill.configure do |config|
    config.default_currency = 'RUB'
    config.max_connections = 10
    config.database = YAML.load(ERB.new(IO.read('./config/database.yml')).result)[Rails.env].symbolize_keys
  end
rescue Sequel::DatabaseError => err
  Rails.logger.error err
end
