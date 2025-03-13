# config valid only for current version of Capistrano
lock "3.7.2"

set :application, 'billing.kiiiosk.ru'
set :repo_url, 'https://github.com/openbill-service/openbill-admin'
set :deploy_to, '/home/wwwkiiiosk/billing.kiiiosk.ru'

# set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

append :linked_files, '.env'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

desc 'Notify http://bugsnag.com'
namespace :deploy do
  task :notify_bugsnag do
    run_locally do
      execute :rake, 'bugsnag:deploy BUGSNAG_API_KEY=ec71d59dddaf657faa0073c322a8eff4'
    end
  end
  # after :finishing, 'notify_bugsnag'
end

append :linked_files, "config/master.key"

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

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
