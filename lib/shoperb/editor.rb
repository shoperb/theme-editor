require 'shoperb/configuration'

module Shoperb

  class << self
    attr_accessor :config

    def with_configuration options
      self.config = Shoperb::Configuration.new(options.to_hash)
      begin
        yield
      ensure
        self.config.save
      end
    end
  end

end