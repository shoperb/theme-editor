require "logger"
require "colorize"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/module/delegation"

module Shoperb

  module Logger

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

    class << self

      LEVELS.each do |name, opts|
        delegate name.downcase, to: :logger
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

end
