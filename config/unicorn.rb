require File.realpath(__FILE__ + '/../settings')

rails_env = ENV['RACK_ENV'] || 'production'

APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

worker_processes WORKER_PROCESS
working_directory APP_ROOT
listen APP_ROOT + '/tmp/sockets/unicorn.sock'
listen '0.0.0.0:3031',  tcp_nopush: true
pid APP_ROOT + '/tmp/pids/unicorn.pid'
stderr_path APP_ROOT + '/log/unicorn.stderr.log'
stdout_path APP_ROOT + '/log/unicorn.stdout.log'

if rails_env == 'production'
  worker_processes WORKER_PROCESS
end

# Helps ensure the correct unicorn binary is used when upgrading with USR2
# # See http://unicorn.bogomips.org/Sandbox.html
Unicorn::HttpServer::START_CTX[0] = APP_ROOT + '/bin/unicorn'

timeout 60
preload_app true

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

# Rails breaks unicorn's logger formatting, reset it
# # http://rubyforge.org/pipermail/mongrel-unicorn/2010-October/000732.html
Unicorn::Configurator::DEFAULTS[:logger].formatter = Logger::Formatter.new

# Forcibly clean environment variables between bundlings
# http://www.mail-archive.com/mongrel-unicorn@rubyforge.org/msg00276.html
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.realpath(__FILE__ + '/../../Gemfile')
end

before_fork do |_server, _worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  defined?(Sequel::DATABASES) and
    Sequel::DATABASES.each(&:disconnect)

  # Throttle the master from forking too quickly (for incremental kill-off only)
  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  defined?(Sequel::DATABASES) and
    Sequel::DATABASES.each { |db| db.connect :default }

  $redis.client.reconnect if defined?($redis)
  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end
