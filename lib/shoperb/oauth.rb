require "oauth2"
require "launchy"
require "fileutils"

OAuth2::Response.register_parser(:zip, ["application/zip"]) do |body|
  file = Tempfile.new("theme.zip")
  file.write(body)
  file
end

module Shoperb
  module OAuth

    class << self

      attr_accessor :auth_code, :client, :token, :server

      def pull directory=nil
        require_relative "./theme"
        directory = directory ? "./#{directory}" : "."
        initialize
        response = access_token.get("themes/download")
        Theme.unpack response.parsed, directory
        Theme.clone_models directory
      end

      def push
        require_relative "./theme"
        initialize
        file = Theme.pack
        theme = Faraday::UploadIO.new(file, "application/zip")
        access_token.post("themes/upload", body: { zip: theme })
      ensure
        FileUtils.rm_r(file, verbose: Shoperb.config["verbose"]) if File.exists?(file)
      end

      def sync
      end

      def make_client
        self.client = OAuth2::Client.new(
          Shoperb.config["oauth-client-id"],
          Shoperb.config["oauth-client-secret"],
          site: "#{Shoperb.config["oauth-site"]}/admin",
          token_url: "oauth/token",
          authorize_url: "oauth/authorize"
        ) do |faraday|
          faraday.request  :multipart
          faraday.request  :url_encoded
          faraday.adapter  :net_http
        end
      end

      def initialize
        make_client

        unless have_token?
          url = authorize_url
          self.server = start_server
          sleep 2 # Wait for server to start
          Launchy.open url
          sleep 2 while !have_token?
          self.server.kill
        end
      end

      def get_token
        client.password.get_token(Shoperb.config["oauth-username"], Shoperb.config["oauth-password"], scope: "admin")
      end

      def authorize_url
        client.auth_code.authorize_url(redirect_uri: Shoperb.config["oauth-redirect-uri"], scope: "admin")
      end

      def get_authented_token(code)
        client.auth_code.get_token(code, redirect_uri: Shoperb.config["oauth-redirect-uri"], scope: "admin")
      end

      def access_token
        OAuth2::AccessToken.new(client, get_token.token) if have_token?
      rescue OAuth2::Error => e
        handle_oauth_error e
      end

      def have_token?
        (cache = Shoperb.config["oauth-cache"]) && cache["access_token"] && valid_expired_token?
      end

      def valid_expired_token?
        !Shoperb.config["oauth-cache"]["expires_at"] || Time.at(Shoperb.config["oauth-cache"]["expires_at"].to_i) > Time.now
      end

      def start_server
        require_relative "./oauth/server"
        instance = Server.new
        Thread.new do
          Rack::Handler::WEBrick.run instance, Port: Shoperb.config["port"]
        end
      end

      def handle_oauth_error exception
        case exception.code
          when "invalid_client"
            Shoperb.config.reset("oauth-client-id", "oauth-client-secret", "oauth-cache")
        end
        raise exception
      end
    end

  end
end
