require "active_support/all"
require "haml"
require "rack"
require "pry"
require "shoperb_liquid"

require_relative 'shoperb_theme_editor/ext'

autoload :OpenStruct,         "ostruct"
autoload :FileUtils,          "fileutils"
autoload :Zip,                "zip"
autoload :Pathname,           "pathname"
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
autoload :Sequel,             "sequel"
require 'faraday/multipart'
require_relative 'shoperb_theme_editor/ext/sequel.rb'

module Shoperb module Theme
  module Editor
    extend self
    mattr_accessor :config
    delegate :[], :[]=, :reset, to: :config

    def with_configuration options, *args
      self.config = Configuration.new(options.to_hash.select { |_, value| !value.nil? }, *args)
      `mkdir -p #{Utils.base+ "data"}`
      Sequel::Model.db= Sequel.sqlite((Utils.base + "data/data.db").to_s)
      begin
        yield
      rescue Interrupt => e
        exit(130)
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

    def handle content=local_spec_content
      spec(content)["handle"]
    end

    def spec content=local_spec_content
      JSON.parse(content)
    end

    def settings_data
      unless File.exist?('config/settings_data.json')
        if File.exist?('presets/default.json')
          File.open('config/settings_data.json', 'w') do |f|
            settings = JSON.parse(File.read('presets/default.json'))['settings']
            f.write JSON.pretty_generate({ general: settings })
          end
        end
      end

      if File.exist?('config/settings_data.json')
        JSON.parse(File.read('config/settings_data.json'))
      end
    end

    def local_spec_content
      @local_spec_content ||= begin
        if File.exist?(path = Utils.base + "config/spec.json")
          File.read(path)
        else
          new_spec_content
        end
      end
    end

    # if spec is missing (for old themes)
    def new_spec_content
      content = JSON.parse(File.read(path = Utils.base + '.shoperb'))
      spec_content = {
        handle: content['handle'],
        compile: {
          stylesheets: ['application.css'],
          javascripts: ['application.js']
        }
      }.to_json
      Dir.mkdir 'config' unless File.exist?('config')
      File.open('config/spec.json', 'w') {|f| f.write(spec_content) }
      spec_content
    end

    # general theme settings (styles)
    def theme_settings
      (settings_data ? settings_data['general'].presence : nil) || {}
    end

    def presets
      res = []

      Pathname.glob(Utils.base + "presets/*.json") do |path|
        content = File.read(path)
        data = JSON.parse(content) rescue { "settings" => { } }

        res.push([nil, data["settings"]]) if data["default"]
        res.push([data["name_key"], data["settings"]])
      end

      res.to_h
    end

    def compiler asset_url, digests: true, **options
      Artisans::ThemeCompiler.new(
        File.expand_path(Utils.base),
        asset_url,
        settings: theme_settings,
        compile: spec["compile"],
        file_reader: SprocketsFileReader.new(digests: digests)
      )
    end

    class SprocketsFileReader
      def initialize(digests: true)
        @digests = digests
      end

      def read(file)
        File.read(file) if File.file?(file)
      end

      def find_digest(path)
        @digests && File.exist?(path) ? Digest::MD5.hexdigest(File.read(path)) : ''
      end
    end
  end
end end
