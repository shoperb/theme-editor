require "colorize"

module Shoperb
  module Logger
    extend self

    LEVELS = {
      "DEBUG" => { color: :green },
      "INFO" => { mode: :bold },
      "ERROR" => { color: :red }
    }

    mattr_accessor :logger do
      ::Logger.new(STDOUT).tap do |log|
        log.formatter = proc do |severity, datetime, progname, msg|
          msg.colorize(LEVELS[severity])
        end
      end
    end

    LEVELS.each do |name, opts|
      define_method name.downcase do |message, &block|
        Array(message).each do |msg|
          logger.send(name.downcase, msg, &block)
        end
      end
    end

    alias :success :debug

    def notify msg
      e, result = nil, nil
      self.info      "          #{msg}"
      action_result = begin
        result = yield
      rescue Exception => e
        false
      end
      self.info "\r"
      if action_result
        self.success "SUCCESS   #{msg}"
      else
        self.error   "ERROR     #{msg}"
      end
      self.info "\n"
      raise e if e
      result
    end

  end
end
