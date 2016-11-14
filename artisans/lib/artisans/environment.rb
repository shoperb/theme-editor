require_relative 'file_importers/sass_liquid'
require_relative 'processors/scss_processor'
require_relative 'cached_environment'

module Artisans
  #
  # Supplying sprockets environment with correct assets paths, custom file importer for Sass::Engine
  # and custom SassProcessor
  #
  class Environment < ::Sprockets::Environment
    attr_reader :sources_path, :drops, :assets_url, :domain, :theme

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

    def initialize **options, &block
      @sources_path = options[:sources_path]
      @drops        = options[:drops]
      @domain       = options[:domain]
      @theme        = options[:theme]
      @assets_url   = Pathname.new(options[:assets_url])
      super(&block)

      assets_path = sources_path.join('assets')


      context_class.include Environment.functions

      context_class.class_eval %Q{
        def asset_path(path, options = {})
          File.join("#{assets_path}",path)
        end
      }

      append_path(assets_path)
      # append_path(assets_path.join('stylesheets'))
      # append_path(assets_path.join('javascripts'))

      importer = Artisans::FileImporters::SassLiquid.new(assets_path.join('stylesheets'), drops)

      self.config = hash_reassoc(config, :paths) { |paths| paths.push(importer) }

      register_engine '.scss', Artisans::Processors::ScssProcessor
    end

    def cached
      Artisans::CachedEnvironment.new(self, domain: domain, theme: theme)
    end
  end
end
