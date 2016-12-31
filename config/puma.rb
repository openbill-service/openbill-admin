# Change to match your CPU core count
require './config/settings'
workers 2

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
#shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
# bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
# stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
#pidfile "#{shared_dir}/pids/puma.pid"
#state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require 'rails'
  require 'openbill'

  Openbill.configure do |config|
    config.default_currency = 'RUB'
    config.max_connections = MAX_CONNECTIONS
    config.database = YAML.load(ERB.new(IO.read('./config/database.yml')).result)[Rails.env].symbolize_keys.merge(reconnect: true)
  end
  Openbill.service.db.extension :connection_validator
  #ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
