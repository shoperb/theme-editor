module Shoperb
  module CustomSprockets

    def self.new **templates
      Sprockets::Environment.new do |env|
        env.register_engine ".sass",   Sprockets::LazyProcessor.new { templates[:sass] }, mime_type: "text/css"
        env.register_engine ".scss",   Sprockets::LazyProcessor.new { templates[:scss] }, mime_type: "text/css"
        env.instance_variable_set("@engines", env.engines.slice(".coffee", ".less", ".sass", ".scss").freeze)
        yield(env) if block_given?
      end
    end

    module Compile

      mattr_accessor :sass_functions do
        Module.new do
          def asset_url(path)
            ::Sass::Script::String.new("url(\"/system/assets/#{Shoperb["oauth-site"]}/#{Shoperb["handle"]}/#{path.value}\")")
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

      mattr_accessor :sass_template do
        Class.new(Sprockets::SassTemplate) do
          def initialize(options = {}, &block)
            @cache_version = options[:cache_version]

            @functions = Module.new do
              class_eval(&block) if block_given?
              include Compile.sass_functions
            end
          end
        end
      end

      mattr_accessor :scss_template do
        Class.new(sass_template) do
          def self.syntax
            :scss
          end
        end
      end

      mattr_accessor :all do
        CustomSprockets.new(sass: sass_template, scss: scss_template) do |env|
          env.append_path "assets"
        end
      end

    end

    module Serve

      mattr_accessor :sass_functions do
        Module.new do

          def asset_url(path)
            ::Sass::Script::String.new("url(\"/assets/#{path.value}\")")
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

      mattr_accessor :sass_template do
        Class.new(Sprockets::SassTemplate) do
          def initialize(options = {}, &block)
            @cache_version = options[:cache_version]

            @functions = Module.new do
              include Serve.sass_functions
              class_eval(&block) if block_given?
            end
          end
        end
      end

      mattr_accessor :scss_template do
        Class.new(sass_template) do
          def self.syntax
            :scss
          end
        end
      end

      mattr_accessor :all do
        CustomSprockets.new(sass: sass_template, scss: scss_template) do |env|
          %w(assets data/assets).each do |path|
            env.append_path path
          end
        end
      end
    end

  end
end
