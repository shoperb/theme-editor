require "active_support/all"
require "haml"
require "rack"
require "pry"

autoload :OpenStruct,         "ostruct"
autoload :FileUtils,          "fileutils"
autoload :Zip,                "zip"
autoload :Pathname,           "pathname"
autoload :Rollbar,            "rollbar"
autoload :Tempfile,           "tempfile"
autoload :Time,               "time"
autoload :OAuth2,             "oauth2"
autoload :Faraday,            "faraday"
autoload :Launchy,            "launchy"
autoload :I18n,               "i18n"
autoload :CoffeeScript,       "coffee_script"
autoload :Sass,               "sass"
autoload :ActionView,         "action_view"
autoload :WEBrick,            "webrick"
autoload :ActionDispatch,     "action_dispatch"
autoload :Sinatra,            "sinatra"
autoload :YAML,               "yaml"
autoload :JSON,               "json"
autoload :Logger,             "logger"
autoload :URI,                "uri"
autoload :Mime,               "action_dispatch/http/mime_type"
autoload :Slop,               "slop"
autoload :ActiveHash,         "active_hash"
autoload :ActiveYaml,         "active_hash"

autoload :Kaminari,           "kaminari"
Kaminari.autoload :PaginatableArray, "kaminari/models/array_extension"

module Shoperb module Theme
  module Editor
    extend self
    mattr_accessor :config
    delegate :[], :[]=, :reset, to: :config

    def with_configuration options, *args
      # TODO: Use compact instead of select when updating Rails to >= 4.1
      self.config = Configuration.new(options.to_hash.select { |_, value| !value.nil? }, *args)
      begin
        yield
      rescue Exception => e
        Error.report(e)
      ensure
        self.config.save
      end
    end

    def autoload_all mod, folder
      Gem.find_files(
        Pathname.new("shoperb_theme_editor/#{folder}/*.rb").cleanpath.to_s
      ).each { |path|
        name = Pathname.new(path).basename(".rb")
        mod.autoload :"#{name.to_s.sub(/.*\./, '').camelize}",
          Pathname.new("shoperb_theme_editor/#{folder}/#{name}").cleanpath.to_s
      }
    end

    autoload_all self, "/"
  end
end end
