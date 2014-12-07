Rollbar.configure do |config|
  config.access_token = "2e62f33d5beb4a86b304080111e64c26"
  config.environment = "production"
  config.exception_level_filters.merge!(
    "Shoperb::Theme::Editor::Error" => "warning",
    "Liquid::SyntaxError" => "warning",
    "Liquid::ArgumentError" => "warning",
    "OAuth2::Error" => "warning"
  )
  config.default_logger = lambda { Logger.new("/dev/null") }
  config.use_async = true
  config.async_handler = Proc.new { |payload|
    Thread.new { Rollbar.process_payload(payload) }
  }
end
module Shoperb module Theme module Editor
  class Error < Exception
    def self.report e
      display = "\r#{e.class.name}"
      display += " => #{e.message}" if e.message.presence
      puts e.backtrace
      Logger.error "#{display}\n"
      # Report all errors for now
      #unless Rollbar.configuration.exception_level_filters.has_key?(e.class.to_s)
      # ::Rollbar.report_exception(e)
      #end
    end
  end
end end end
