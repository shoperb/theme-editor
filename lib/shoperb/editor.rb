require "active_support/all"

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
autoload :Rack,               "rack"
autoload :I18n,               "i18n"
autoload :CoffeeScript,       "coffee_script"
autoload :Sass,               "sass"
autoload :Liquid,             "liquid"
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
autoload :Sprockets,          "sprockets"
autoload :ActiveHash,         "active_hash"
autoload :ActiveYaml,         "active_hash"

require "haml"

module Shoperb
  extend self
  mattr_accessor :config
  delegate :[], :[]=, :reset, to: :config

  def with_configuration options, *args
    self.config = Configuration.new(options.to_hash.compact, *args)
    begin
      yield
    rescue Exception => e
      Error.report(e)
    ensure
      self.config.save
    end
  end

  def autoload_all mod, folder
    Gem.find_files("#{folder}/*.rb").each { |path|
      name = Pathname.new(path).basename(".rb")
      mod.autoload :"#{name.to_s.camelize}", "#{folder}/#{name}"
    }
  end

  autoload_all self, "shoperb"

end