set :application, 'billing.kiiiosk.ru'
set :stage, :production
set :unicorn_restart_cmd, "service unicorn-#{fetch(:application)} upgrade"
set :repo_url, 'git@github.com:dapi/openbill-admin.git'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, -> { "/home/wwwkiiiosk/#{fetch(:application)}" }
server 'srv-1.kiiiosk.ru', user: 'wwwkiiiosk', port: 22, roles: %w(web app)
server 'srv-2.kiiiosk.ru', user: 'wwwkiiiosk', port: 22, roles: %w(web app)
set :rails_env, :production
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :production)
