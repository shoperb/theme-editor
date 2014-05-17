require 'oauth2'
require 'launchy'

require_relative './oauth/server'

module Shoperb
  module OAuth

    class << self

      attr_accessor :auth_code, :client, :token, :server

      def pull
        initialize
        access_token.get 'theme/download'
      end

      def push
        initialize
      end

      def sync
        initialize
      end

      def initialize
        self.client = OAuth2::Client.new(
          Shoperb.config[:'oauth-client-id'],
          Shoperb.config[:'oauth-client-secret'],
          site: Shoperb.config[:'oauth-site'],
          token_url: 'oauth/token',
          authorize_url: 'oauth/authorize'
        )
        unless have_token?
          self.server = start_server
          sleep 2 # Wait for server to start
          Launchy.open authorize_url
          sleep 2 while !have_token?
          self.server.kill
        end
      end

      def get_token
        client.password.get_token(Shoperb.config[:'oauth-username'], Shoperb.config[:'oauth-password'])
      end

      def authorize_url
        client.auth_code.authorize_url(redirect_uri: Shoperb.config[:'oauth-redirect-uri'], scope: 'admin')
      end

      def get_authented_token(code)
        client.auth_code.get_token(code, redirect_uri: Shoperb.config[:'oauth-redirect-uri'])
      end

      def access_token
        OAuth2::AccessToken.new(client, get_token.token) if have_token?
      end

      def have_token?
        (Shoperb.config[:'oauth-cache']['access_token']).to_s.size > 0 && valid_expired_token?
      end

      def valid_expired_token?
        Shoperb.config[:'oauth-cache']['expires_at'].to_s.size == 0 || (Shoperb.config[:'oauth-cache']['expires_at'].to_s.size > 0 && Time.at(Shoperb.config[:'oauth-cache']['expires_at'].to_i) > Time.now)
      end

      def start_server
        instance = Server.new
        Thread.new do
          Rack::Handler::WEBrick.run instance, Port: Shoperb.config[:port]
        end
      end
    end

  end
end
