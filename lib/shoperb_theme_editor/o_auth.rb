OAuth2::Response.register_parser(:zip, ["application/zip"]) do |body|
  Shoperb::Theme::Editor::Utils.mk_tempfile body, "theme-", ".zip"
end

OAuth2::Response.register_parser(:json, ["application/json"]) do |body|
  JSON.parse(body)
end

module Shoperb module Theme module Editor
  module OAuth
    extend self
    mattr_accessor :auth_code, :client, :token

    def clone_remote
      initialize
      unless Editor["handle"]
        response = access_token.get(Pathname.new("themes").cleanpath.to_s).parsed
        Configuration::QUESTION["handle"] = "Please choose a theme [#{response.map { |hash| hash["handle"] }.join(", ")}]"
      end
      pull
    end

    def pull
      initialize
      atoken = access_token
      response = Logger.notify "Downloading" do
        atoken.get(Pathname.new("themes/download").cleanpath.to_s)
      end

      Theme.unpack response.parsed
      Theme.clone_models
    end

    def push
      initialize
      file = Theme.pack
      theme = Faraday::UploadIO.new(file, "application/zip")
      atoken = access_token
      Logger.notify "Uploading #{Editor["handle"]}" do
        atoken.post(Pathname.new("themes/upload").cleanpath.to_s, body: { zip: theme })
      end
    ensure
      Utils.rm_tempfile file
    end

    def sync
      initialize
      Sync.images
      Sync.categories
      Sync.products
      Sync.collections
      Sync.vendors
      Sync.addresses
      Sync.pages
      Sync.shop
      Sync.menus
      Sync.blog_posts
    end

    def oauth_client
      return @client if defined?(@client)

      @client = OAuth2::Client.new(
        Editor["oauth-client-id"],
        Editor["oauth-client-secret"],
        site: "#{Editor["server"]["protocol"]}://#{Editor["oauth-site"]}.#{Editor["server"]["url"]}/admin",
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
      oauth_client.password.get_token(Editor["oauth-username"], Editor["oauth-password"], scope: "admin")
    end

    def authorize_url
      oauth_client.auth_code.authorize_url(redirect_uri: Editor["oauth-redirect-uri"], scope: "admin")
    end

    def get_authented_token(code)
      oauth_client.auth_code.get_token(code, redirect_uri: Editor["oauth-redirect-uri"], scope: "admin")
    end

    def access_token
      OAuth2::AccessToken.new(oauth_client, get_token.token) if have_token?
    rescue OAuth2::Error => e
      handle_oauth_error e
    end

    def have_token?
      (cache = Editor["oauth-cache"]) && cache["access_token"] && valid_expired_token?
    end

    def valid_expired_token?
      !Editor["oauth-cache"]["expires_at"] || Time.at(Editor["oauth-cache"]["expires_at"].to_i) > Time.now
    end

    def start_server url
      thread = Thread.new do
        Rack::Handler::WEBrick.run Server.new,
          Port: Editor["port"],
          StartCallback: -> { Launchy.open url },
          AccessLog: [],
          Logger: WEBrick::Log::new("/dev/null", 7)
      end
      sleep(0.5) while !have_token?
      thread.kill
    end

    def handle_oauth_error exception
      case exception.code
        when "invalid_client"
          Editor.reset("oauth-client-id", "oauth-client-secret", "oauth-cache")
      end
      raise exception
    end

    Editor.autoload_all self, "shoperb_theme_editor/o_auth"

  end
end end end
