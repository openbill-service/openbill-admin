Openbill.configure do |config|
  config.default_currency = 'RUB'
  config.max_connections = 12
  config.database = YAML.load(ERB.new(IO.read('./config/database.yml')).result)[Rails.env].symbolize_keys.merge(reconnect: true)
end
Openbill.service.db.extension :connection_validator
