require 'json'
require 'hashie'
module Shoperb
  class Configuration < Hashie::Trash
    include Hashie::Extensions::DeepMerge
    include Hashie::Extensions::IgnoreUndeclared

    property :'oauth-client-id'
    property :'oauth-client-secret'
    property :'oauth-username'
    property :'oauth-password'
    property :'oauth-redirect-uri'
    property :'oauth-site'
    property :'oauth-cache'
    property :port

    def initialize options={}
      super()
      deep_merge!(self.class.defaults)
      deep_merge!(self.class.conf)
      deep_merge!(options)
    end

    def save
      File.open(self.class.file, 'w') { |f| f.write(JSON.pretty_generate(self)) }
    end

    def self.destroy
      File.delete(file) if File.exist?(file)
    end

    def self.defaults
      {
        :'oauth-client-id' => '',
        :'oauth-client-secret' => '',
        :'oauth-username' => '',
        :'oauth-password' => '',
        :'oauth-redirect-uri' => '',
        :'oauth-site' => 'http://sso.shoperb.biz',
        :'oauth-cache' => {},
        :port => '3000'
      }
    end

    def self.conf
      File.exist?(file) ? JSON.parse(File.read(file)) || {} : {}
    end

    def self.file
      File.expand_path('~/.shoperb')
    end
  end
end