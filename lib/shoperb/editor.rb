require 'shoperb/configuration'

module Shoperb

  class << self
    attr_accessor :config

    def with_configuration options, *args
      self.config = Shoperb::Configuration.new(options.to_hash, *args)
      begin
        yield
      ensure
        self.config.save
      end
    end
  end

end