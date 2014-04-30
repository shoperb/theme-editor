require 'oauth2'
require 'launchy'

require_relative './oauth/server'

module Shoperb
  module OAuth

    class << self

      attr_accessor :auth_code, :client, :token, :server

      def pull shop_id, name = nil
        with_token do
          self.token.get("/api/v1/shops/#{shop_id}/download_theme")
        end
      end

      def push shop_id
        with_token do

        end
      end

      def with_token
        self.client = OAuth2::Client.new Shoperb.config[:'oauth-client-id'], Shoperb.config[:'oauth-client-secret'], site: Shoperb.config[:'oauth-site'], token_method: :post
        get_token
        yield if block_given?
      end

      def get_token
        if Shoperb.config[:'oauth-cache'].any?
          self.token = OAuth2::AccessToken.new(self.client, Shoperb.config[:'oauth-cache'][:access_token], refresh_token: Shoperb.config[:'oauth-cache'][:refresh_token])
        else
          self.server = start_server
          sleep 2 # Wait for server to start
          Launchy.open self.client.auth_code.authorize_url(redirect_uri: Shoperb.config[:'oauth-redirect-uri'])
          i = 60
          while !self.auth_code
            i = i - 2
            (self.server.kill; exit) if i == 0
            sleep 2 # Wait for callback
          end
          self.server.kill
          self.token = self.client.auth_code.get_token(self.auth_code, redirect_uri: Shoperb.config[:'oauth-redirect-uri'])
          Shoperb.config[:'oauth-cache'] = self.token.to_hash
        end
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
