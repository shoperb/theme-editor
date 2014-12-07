require "sprockets"

module Shoperb module Theme module Sprockets
  class SassTemplate < ::Sprockets::SassTemplate
    cattr_accessor :functions do
      Module.new do
        def asset_url(path)
          ::Sass::Script::String.new("url(\"/system/assets/#{sprockets_environment.domain}/#{sprockets_environment.theme}/#{path.value}\")")
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
        include self.class.functions
        class_eval(&block) if block_given?
      end
    end
  end

  class ScssTemplate < SassTemplate
    def self.syntax
      :scss
    end
  end

  class Environment < ::Sprockets::Environment
    attr_accessor :domain, :theme
    def initialize *args, &block
      super(*args, &block)
      register_engine ".sass", Sprockets::LazyProcessor.new { SassTemplate }, mime_type: "text/css"
      register_engine ".scss", Sprockets::LazyProcessor.new { ScssTemplate }, mime_type: "text/css"
    end
  end
end end end
