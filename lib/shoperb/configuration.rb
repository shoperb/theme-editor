require 'json'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'

module Shoperb
  class Configuration < HashWithIndifferentAccess
    attr_accessor :file

    def initialize options={}, directory = nil
      self.file = "#{directory ? "./#{directory}" : '.'}/config/shoperb"
      FileUtils.mkdir_p(File.dirname(self.file))
      super()
      merge!(conf)
      merge!(options)
    end

    def save
      File.open(self.file, 'w') { |f| f.write(JSON.pretty_generate(self)) }
    end

    def [] name
      super(name).presence || (self[name.to_sym] = ask(name))
    end

    def ask name
      default = self.class.defaults[name.to_s].presence
      if question = self.class.question[name.to_s]
        puts question
        default = self.class.defaults[name.to_s].presence
        puts "Default is '#{default}'" if default
        gets.strip.presence || default
      end || default
    end

    def destroy
      File.delete(file) if File.exist?(file)
    end

    def conf
      File.exist?(file) ? JSON.parse(File.read(file)).with_indifferent_access || {} : {}
    end

    def self.question
      {
        'oauth-site' => 'Insert Shoperb url',
        'oauth-username' => 'Insert Shoperb username',
        'oauth-password' => 'Insert Shoperb password',
        'oauth-client-id' => 'Insert Shoperb OAuth client id',
        'oauth-client-secret' => 'Insert Shoperb OAuth client secret',
        'oauth-redirect-uri' => 'Insert Shoperb OAuth callback url'
      }
    end

    def self.defaults
      {
        'oauth-redirect-uri' => 'http://localhost:4000/callback',
        'oauth-site' => 'http://perfectline.shoperb.biz',
        'oauth-cache' => {}.with_indifferent_access,
        'port' => '4000',
        'verbose' => false
      }
    end

  end
end