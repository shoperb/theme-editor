require "shoperb/utils"
require "shoperb/logger"
require "shoperb/rollbar"
require "shoperb/configuration"

module Shoperb

  class << self
    attr_accessor :config

    def with_configuration options, *args
      self.config = Shoperb::Configuration.new(options.to_hash, *args)
      begin
        yield
      rescue Exception => e
        Rollbar.report_exception(e)
        raise e
      ensure
        self.config.save
      end
    end
  end

end