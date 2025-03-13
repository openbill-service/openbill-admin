# config valid only for current version of Capistrano
lock "3.19.2"

set :user, 'app'
set :application, 'openbill-admin'
set :repo_url, ENV.fetch('CAP_REPO', 'https://github.com/openbill-service/openbill-admin')
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

append :linked_files, '.env'
append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :deploy do
  namespace :check do
    before :linked_files, :upload_env do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/.env ]")
          upload! '.env.production', "#{shared_path}/.env"
        end
      end
    end
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end

set :dotenv_hook_commands, %w[rake rails ruby]
Capistrano::DSL.stages.each do |stage|
  after stage, 'dotenv:hook'
end
