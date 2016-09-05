module Artisans
  class CachedEnvironment < ::Sprockets::CachedEnvironment
    attr_accessor :assets_url
    def initialize(environment, options={})
      self.assets_url = environment.assets_url
      @domain       = options[:domain]
      @theme        = options[:theme]
      super(environment)
    end
  end
end
