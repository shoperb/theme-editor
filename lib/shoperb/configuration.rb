require "json"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/except"

module Shoperb
  class Configuration < HashWithIndifferentAccess

    QUESTION = {
      "oauth-site" => "Insert Shoperb url",
      "oauth-username" => "Insert Shoperb username",
      "oauth-password" => "Insert Shoperb password"
    }.with_indifferent_access

    HARDCODED = {
      "oauth-client-id" => "bjpgvfwp4rtyq7g0gb7ravovehalhm7",
      "oauth-client-secret" => "j31wvmre3dkxyx82tj08tmjdjalv5lp",
      "oauth-redirect-uri" => "http://localhost:4000/callback"
    }.with_indifferent_access

    DEFAULTS = {
      "oauth-cache" => {}.with_indifferent_access,
      "port" => "4000",
      "verbose" => false
    }.with_indifferent_access

    attr_accessor :file

    def initialize options={}, directory = nil
      self.file = "#{directory ? "./#{directory}" : "."}/.shoperb"
      FileUtils.mkdir_p(File.dirname(self.file))
      super()
      merge!(conf)
      merge!(options)
      merge!(HARDCODED)
    end

    def save
      File.open(self.file, "w") { |f| f.write(JSON.pretty_generate(self.except(*HARDCODED.keys))) }
    end

    def [] name
      super(name).presence || (self[name] = ask(name))
    end

    def ask name
      default = DEFAULTS[name].presence
      if question = QUESTION[name]
        puts question
        default = DEFAULTS[name].presence
        puts "Default is '#{default}'" if default
        gets.strip.presence || default
      end || default
    end

    def reset *names
      names.each { |name| self[name] = DEFAULTS[name] }
    end

    def destroy
      File.delete(file) if File.exist?(file)
    end

    def conf path=self.file
      File.exist?(path) && (content = File.read(path).presence)? JSON.parse(content) || {} : {}
    end

  end
end