OAuth2::Response.register_parser(:zip, ["application/zip"]) do |body|
  Shoperb::Theme::Editor::Utils.mk_tempfile body, "theme-", ".zip"
end

OAuth2::Response.register_parser(:json, ["application/json"]) do |body|
  JSON.parse(body)
end

module Shoperb module Theme module Editor
  module Api
    extend self
    mattr_accessor :auth_code, :client, :token

    def pull
      prepare
      response = request Pathname.new("themes/download").cleanpath.to_s, method: :get, notify: -> { "Downloading" }
      Package.unzip response.parsed
    end

    def push
      prepare
      file = Package.zip
      theme = Faraday::UploadIO.new(file, "application/zip")
      request Pathname.new("themes/upload").cleanpath.to_s, method: :post, notify: -> { "Uploading #{Editor["handle"]}" }, body: { zip: theme }
    ensure
      Utils.rm_tempfile file
    end

    def sync
      prepare
      Sync.products
      Sync.shop
      Sync.images
      Sync.collections
      Sync.vendors
      Sync.addresses
      Sync.pages
      Sync.menus
      Sync.links
      Sync.blog_posts
      Mounter::Model::Base.save
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

    def prepare
      oauth_client
      Logger.notify "Asking for permission" do
        start_server(authorize_url)
      end unless have_token?
    end

    def request url, notify: false, method:, **options, &block
      response = get_response(url, notify: notify, method: method, **options, &block)

      if /\/admin\/authenticate$/ =~ response.response.env.url.to_s
        Editor.reset("oauth-cache")
        get_response(url, notify: notify, method: method, **options, &block)
      else
        response
      end
    end

    def get_response url, notify: false, method:, **options, &block
      if notify
        atoken = access_token
        Logger.notify notify[] do
          atoken.send(method, url, **options, &block)
        end
      else
        access_token.send(method, url, **options, &block)
      end
    end

    def get_token
      oauth_client.password.get_token(Editor["oauth-username"], Editor["oauth-password"], scope: "admin")
    end

    def authorize_url
      oauth_client.auth_code.authorize_url(redirect_uri: Editor["oauth-redirect-uri"], scope: "admin", response_type: "code_and_token")
    end

    def get_authented_token(code)
      oauth_client.auth_code.get_token(code, redirect_uri: Editor["oauth-redirect-uri"], scope: "admin")
    end

    def access_token
      if have_token?
        cache = Editor["oauth-cache"]
        OAuth2::AccessToken.new(oauth_client, cache["access_token"], refresh_token: cache["refresh_token"])
      else
        OAuth2::AccessToken.new(oauth_client, get_token.token)
      end
    rescue OAuth2::Error => oauth_error
      handle_oauth_error oauth_error
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
          Logger: WEBrick::Log::new(Os["/dev/null"], 7)
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

    Editor.autoload_all self, "api"

  end
end end end
