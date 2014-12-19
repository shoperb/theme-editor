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
      self.info      "#{fill(msg)}".rstrip
      result = begin
        self.info "\r"
        yield
      rescue Exception => e
        self.error   fill(msg, " [FAILED]")
      else
        self.success fill(msg, " [OK]")
      ensure
        self.info "\n"
      end
      raise e if e
      result
    end

    def cols
      @cols ||= begin
        IO.console.winsize[1] - 1
      end
    end

    def fill msg, ending=""
      "#{msg.ljust(cols)[0..cols-ending.length]}#{ending}"
    end

  end
end end end
