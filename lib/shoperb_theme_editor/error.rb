Raven.configure do |config|
  config.dsn = 'https://71ae0199b499419da0ffe2a9695871ca:bc1386ebe0d4486aac1e1b41c3011f41@sentry.io/1273398'
end

module Shoperb module Theme module Editor
  class Error < Exception
    def self.report e
      display = "\r#{e.class.name}"
      display += " => #{e.message}" if e.message.presence
      puts e.backtrace#.reverse
      Logger.error "#{display}\n"
      Raven.capture_exception(e)
    end
  end
end end end
