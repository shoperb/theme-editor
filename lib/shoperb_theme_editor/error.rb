require "raven"

# Raven.configure do |config|
#   config.dsn = 'https://71ae0199b499419da0ffe2a9695871ca:bc1386ebe0d4486aac1e1b41c3011f41@sentry.io/1273398'
#   config.excluded_exceptions += [
#     "Liquid::FileSystemError",
#     "Liquid::ArgumentError",
#     "Liquid::SyntaxError",
#     "Liquid::UndefinedFilter",
#     "Liquid::UndefinedDropMethod",
#     "Liquid::UndefinedVariable",
#     "Shoperb::Theme::Editor::Error"
#   ]
# end

module Shoperb module Theme module Editor
  class Error < Exception
    def self.report exception
      log(exception)
      # Raven.capture_exception(exception)
    end

    def self.report_rack exception, env
      log(exception)
      # Raven::Rack.capture_exception(exception, env)
    end

    def self.log exception
      display = "\r#{exception.class.name}"
      display += " => #{exception.message}" if exception.message.presence
      puts exception.backtrace
      Logger.error "#{display}\n"
    end
  end
end end end
