source 'https://rubygems.org'

def darwin?
  RbConfig::CONFIG['host_os'] =~ /darwin/
end

def windows_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /mingw|mswin/i ? require_as : false
end

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end
# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

source 'https://rails-assets.org' do
  # Не получилось его запустить, поэтому пользуемся тем, что
  # лежит в vendor/assets
  # gem 'rails-assets-eonasdan-bootstrap-datetimepicker'
  gem 'rails-assets-tether', '>= 1.1.0'
  gem 'rails-assets-select2'
  gem 'rails-assets-better-dom'
  gem 'rails-assets-better-i18n-plugin'
  gem 'rails-assets-better-popover-plugin'
  gem 'rails-assets-better-form-validation'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# gem 'mini_racer'
#
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'kaminari'
gem 'bootstrap-kaminari-views', github: 'klacointe/bootstrap-kaminari-views', branch: 'bootstrap4'
gem 'pg'
gem 'money'
gem 'money-rails'
gem 'slim-rails'
gem 'nprogress-rails'
gem 'semver2'
gem 'bootstrap', '~> 4.0.0.alpha6'

gem 'rack_password'

gem 'ransack'
gem 'foreman'

gem 'bugsnag'
gem 'virtus'
gem 'hashie'

gem 'simple-navigation', github: 'andi/simple-navigation'
gem 'simple-navigation-bootstrap'

gem 'font-awesome-rails'
gem 'simple_form', github: 'plataformatec/simple_form'

gem 'active_link_to'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'puma'

gem 'momentjs-rails'

# PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'pry-rails'
  gem 'pry-theme'

  gem 'pry-pretty-numeric'
  # gem 'pry-highlight'
  # step, next, finish, continue, break
  gem 'pry-nav'

  gem 'pry-doc'
  gem 'pry-docmore'

  # Добавляет show-stack
  gem 'pry-stack_explorer'

  gem 'listen', '~> 3.0'
  gem 'guard', '> 2.12'
  gem 'terminal-notifier-guard', '~> 1.6.1', require: darwin_only('terminal-notifier-guard')

  # gem 'guard-rspec'
  gem 'guard-rails'
  # gem 'guard-shell'
  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  # gem 'guard-rubocop'

  gem 'rspec'
  gem 'rspec-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-rbenv-install', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-secrets-yml', require: false
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-rails-console', require: false
  # gem 'capistrano-sidekiq', require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Added at 2021-12-06 17:54:46 +0300 by danil:
gem "dotenv-rails", "~> 2.7"
