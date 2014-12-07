require "colorize"
require "io/console"
module Shoperb module Theme module Editor
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
      rows, cols = IO.console.winsize
      cols -= 1
      e, result = nil, nil
      self.info      "#{msg.ljust(cols)[0..cols]}".rstrip
      action_result = begin
        result = yield
      rescue Exception => e
        false
      else
        true
      end
      self.info "\r"
      if action_result
        self.success "#{msg.ljust(cols)[0..cols-5]} [OK]"
      else
        self.error   "#{msg.ljust(cols)[0..cols-9]} [FAILED]"
      end
      self.info "\n"
      raise e if e
      result
    end

  end
end end end
