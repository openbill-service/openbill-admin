Bugsnag.configure do |config|
  config.api_key = "ec71d59dddaf657faa0073c322a8eff4"
  config.app_version = AppVersion.format('%M.%m.%p')

  config.notify_release_stages = %w(production staging reproduction)
  config.send_code = true
  config.send_environment = true
end
