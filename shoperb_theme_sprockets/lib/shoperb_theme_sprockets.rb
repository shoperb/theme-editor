require "sprockets"

module Shoperb module Theme module Sprockets
  class SassTemplate < ::Sprockets::SassTemplate
    cattr_accessor :functions do
      Module.new do
        def asset_url(path)
          ::Sass::Script::String.new("url(\"/#{Pathname.new(["system", "assets", sprockets_environment.domain, sprockets_environment.theme, path.value].compact.join("/")).cleanpath}\")")
        end

        protected

        def sprockets_environment
          options[:sprockets][:environment]
        end
        def sprockets_dependencies
          options[:sprockets][:dependencies]
        end
        def sprockets_context
          options[:sprockets][:context]
        end
      end
    end

    def initialize options = {}, &block
      @cache_version = options[:cache_version]

      @functions = Module.new do
        include SassTemplate.functions
        class_eval(&block) if block_given?
      end
    end
  end

  class ScssTemplate < SassTemplate
    def self.syntax
      :scss
    end
  end

  class CachedEnvironment < ::Sprockets::CachedEnvironment
    attr_accessor :domain, :theme
    def initialize(environment)
      self.domain = environment.domain
      self.theme  = environment.theme
      super(environment)
    end
  end

  class Environment < ::Sprockets::Environment
    attr_accessor :domain, :theme
    def initialize **options, &block
      self.domain = options[:domain]
      self.theme  = options[:theme]
      super(&block)
      register_engine ".sass", ::Sprockets::LazyProcessor.new { SassTemplate }, mime_type: "text/css"
      register_engine ".scss", ::Sprockets::LazyProcessor.new { ScssTemplate }, mime_type: "text/css"
    end

    def cached
      CachedEnvironment.new(self)
    end
  end
end end end
