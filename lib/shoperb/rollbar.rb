require "rollbar"

Rollbar.configure do |config|
  config.access_token = "2e62f33d5beb4a86b304080111e64c26"
  config.environment = "production"
end