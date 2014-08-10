OAuth2::Response.register_parser(:zip, ["application/zip"]) do |body|
  Tempfile.new(["theme-",".zip"]).tap do |file|
    file.write(body)
    file.flush
    file.open
  end
end

module Shoperb
  module OAuth
    extend self
    mattr_accessor :auth_code, :client, :token

    def pull
      initialize
      atoken = access_token
      response = Logger.notify "Downloading" do
        atoken.get("themes/download")
      end
      Theme.unpack response.parsed
      Theme.clone_models
    end

    def push
      initialize
      file = Theme.pack
      theme = Faraday::UploadIO.new(file, "application/zip")
      atoken = access_token
      Logger.notify "Uploading" do
        atoken.post("themes/upload", body: { zip: theme })
      end
    ensure
      FileUtils.rm_r(file) if file && File.exists?(file)
    end

    def sync
    end

    def oauth_client
      return @client if defined?(@client)

      @client = OAuth2::Client.new(
        Shoperb["oauth-client-id"],
        Shoperb["oauth-client-secret"],
        site: "#{Shoperb["oauth-site"]}/admin",
        token_url: "oauth/token",
        authorize_url: "oauth/authorize"
      ) do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded
        faraday.adapter  :net_http
      end
    end

    def initialize
      oauth_client
      Logger.notify "Asking for permission" do
        start_server(authorize_url)
      end unless have_token?
    end

    def get_token
      oauth_client.password.get_token(Shoperb["oauth-username"], Shoperb["oauth-password"], scope: "admin")
    end

    def authorize_url
      oauth_client.auth_code.authorize_url(redirect_uri: Shoperb["oauth-redirect-uri"], scope: "admin")
    end

    def get_authented_token(code)
      oauth_client.auth_code.get_token(code, redirect_uri: Shoperb["oauth-redirect-uri"], scope: "admin")
    end

    def access_token
      OAuth2::AccessToken.new(oauth_client, get_token.token) if have_token?
    rescue OAuth2::Error => e
      handle_oauth_error e
    end

    def have_token?
      (cache = Shoperb["oauth-cache"]) && cache["access_token"] && valid_expired_token?
    end

    def valid_expired_token?
      !Shoperb["oauth-cache"]["expires_at"] || Time.at(Shoperb["oauth-cache"]["expires_at"].to_i) > Time.now
    end

    def start_server url
      thread = Thread.new do
        Rack::Handler::WEBrick.run Server.new,
         Port: Shoperb["port"],
         StartCallback: -> { Launchy.open url },
         AccessLog: [],
         Logger: WEBrick::Log::new("/dev/null", 7)
      end
      sleep 2 while !have_token?
      thread.kill
    end

    def handle_oauth_error exception
      case exception.code
        when "invalid_client"
          Shoperb.reset("oauth-client-id", "oauth-client-secret", "oauth-cache")
      end
      raise exception
    end

    Shoperb.autoload_all self, "shoperb/o_auth"

  end
end
