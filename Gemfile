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
gem 'rails'
gem "propshaft"
#
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'kaminari'
gem 'bootstrap-kaminari-views', github: 'klacointe/bootstrap-kaminari-views', branch: 'bootstrap4'
gem "bootstrap-icons-helper", "~> 2.0"
gem 'pg'
gem 'money'
gem 'money-rails'
gem 'slim-rails'
gem 'nprogress-rails'
gem "semver2", github: "haf/semver"
gem 'rack_password'

gem 'ransack'
gem 'foreman'

gem 'bugsnag'
gem 'virtus'
gem 'hashie'

gem 'simple-navigation', github: 'andi/simple-navigation'
gem 'simple-navigation-bootstrap'

gem 'font-awesome-rails'
gem 'simple_form'

gem 'active_link_to'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'puma'

gem 'momentjs-rails'

# PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'


# Added at 2021-12-06 17:54:46 +0300 by danil:
gem "csv", "~> 3.3"

gem "bootsnap", "~> 1.18"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'listen', '~> 3.0'
  gem 'guard', '> 2.12'
  gem 'terminal-notifier-guard', '~> 1.6.1', require: darwin_only('terminal-notifier-guard')

  gem 'guard-bundler'
  gem 'guard-ctags-bundler'

  gem 'rspec'
  gem 'rspec-rails'
end

group :development do
  gem 'kamal', '~> 2.5'
end

gem "thruster", "~> 0.1.12"

gem "cssbundling-rails", "~> 1.4"
