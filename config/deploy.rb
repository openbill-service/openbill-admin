lock '3.5.0'

require 'capistrano-db-tasks'
# require 'new_relic/recipes'
set :scm, :git
set :git_strategy, SubmoduleStrategy
set :git_enable_submodules, 1
# set :format, :pretty
# set :log_level, :debug
# set :pty, true
set :keep_releases, 10

set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/.well-known)

# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :rbenv_type, :user
set :rbenv_ruby, '2.2.4'

set :bundle_without, %w(development test deploy).join(' ')

# set :honeybadger_async_notify, true
# set :honeybadger_deploy_task, 'honeybadger:deploy_with_environment'

# https://github.com/planetio/capistrano-db-tasks/commit/8862ae309eb5262174ee8c33e764cd8ccbb8931b
# Параметры для pg_dump
set :dump_cmd_flags, '--exclude-table-data="sessions|carts|cart_items"'

# if you want to remove the local dump file after loading
set :db_local_clean, false
# if you want to remove the dump file from the server after downloading
set :db_remote_clean, false

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/uploads)
set :local_assets_dir, 'public'

namespace :deploy do
  if ENV['USE_LOCAL_REPO'] == 'true'
    before :deploy, 'deploy:deploy_from_local_repo'
    task :deploy_from_local_repo do
      set :repo_url, "file:///home/wwwmerchantly/#{fetch(:application)}/repo"
      run_locally do
        execute 'tar -zcvf /tmp/repo.tgz ./'
      end
      on roles(:all) do
        execute "mkdir -p /tmp/#{fetch(:application)}.git"
        execute "rm -rvf /home/wwwmerchantly/#{fetch(:application)}/repo/*"
        upload! '/tmp/repo.tgz', '/tmp/repo.tgz'
        execute "tar -zxvf /tmp/repo.tgz -C /home/wwwmerchantly/#{fetch(:application)}/repo"
        execute "cd /home/wwwmerchantly/#{fetch(:application)}/repo&& git remote set-url origin file:///home/wwwmerchantly/#{fetch(:application)}/repo"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do |_server|
      # sidekiqapp = "sidekiq app=/home/#{server.user}/#{fetch(:application)}/current"
      begin
        execute "#{fetch(:unicorn_restart_cmd)}"
      rescue StandardError => err_msg
        if err_msg.to_s.include?('master failed to start, check stderr log for details')
          execute "tail -n 80 #{shared_path}/log/unicorn.stderr.log" do |channel, stream, data|
            puts "#{channel[:host]}: #{data}"
            break if stream == :err
          end
          raise StandardError, 'Не получилось запустить unicorn. Читайте логи выше.'
        end
      end
      on roles(:sidekiq), in: :sequence, wait: 5 do
        unless ENV['RESTART_SIDEKIQ'] == 'false'
          execute 'restart sidekiq-workers || start sidekiq-workers'
        end
      end
    end
  end

  desc 'Debloy bower'
  task :bowerinstall do
    on roles(:web) do
      within release_path do
        execute 'test -f bower.json && bower install || true'
      end
    end
  end

  desc 'clearcache'
  task :clearcache do
    on roles(:web) do
      within release_path do
        execute :rake, 'tmp:cache:clear'
        execute "test -d #{shared_path}/public/assets && find #{shared_path}/public/assets -type f -mtime +10 -print -delete || true"
      end
    end
  end
  desc 'Notify http://bugsnag.com'

  task :notify_bugsnag do
    run_locally do
      execute :rake, 'bugsnag:deploy BUGSNAG_API_KEY=4a44154fd5297480cd452591689a0368', '--trace' # Bugsnag rails
      execute :rake, 'bugsnag:deploy BUGSNAG_API_KEY=b4b0403a0d68f22990b80a757afa7400', '--trace' # Bugsnag JS
    end
  end

  task :sidekiqquiet do
    on roles(:sidekiq) do
      puts capture("pgrep -f 'sidekiq' | xargs kill -USR1")
    end
  end

  unless ENV['OFF_NOTIFY']
    after 'deploy:updated', 'notify_bugsnag'
    # after 'deploy:updated', 'newrelic:notice_deployment'
  end

  before :compile_assets, 'clearcache'
  before :compile_assets, 'bowerinstall'
  after :publishing, :restart
  before :started, :sidekiqquiet
  after :finishing, 'deploy:cleanup'
end
