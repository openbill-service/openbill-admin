set :application, 'billing.stage.rocketwash.ru'
set :unicorn_restart_cmd, "systemctl reload  unicorn-#{fetch(:application)}.service"
set :stage, :production
set :repo_url, 'git@github.com:openbill-service/openbill-admin.git'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, -> { "/opt/openbill/#{fetch(:application)}" }
server '77.221.145.66', user: 'wwwopenbill', port: 22, roles: %w(web app)
set :rails_env, :production
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :production)
