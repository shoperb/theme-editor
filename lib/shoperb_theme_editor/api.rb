OAuth2::Response.register_parser(:zip, ["application/zip"]) do |body|
  Shoperb::Theme::Editor::Utils.mk_tempfile body, "theme-", ".zip"
end

OAuth2::Response.register_parser(:json, ["application/json"]) do |body|
  JSON.parse(body)
end

module Shoperb module Theme module Editor
  EMAIL_SPLITTER = "---\n"
  module Api
    extend self
    mattr_accessor :auth_code, :client, :token

    def pull handle=nil, *args
      prepare
      response = request Pathname.new(["api", "v1", "themes", handle, "download"].compact.join("/")).cleanpath.to_s, method: :get, notify: -> { "Downloading" } do |faraday|
        faraday.options.timeout = 120
        faraday.headers['Current-Shop'] = Editor["oauth-site"]
      end
      Package.unzip response.parsed
    end
    
    def get_emails(params: "", notify: )
      total = 2
      page  = 1
      per   = 1
      while page*per < total do
        response = request Pathname.new(["api", "v1", "emails"].join("/")).cleanpath.to_s + "?" + params, method: :get, notify: ->{ notify } do |faraday|
          faraday.options.timeout = 120
          faraday.headers['Current-Shop'] = Editor["oauth-site"]
        end
        pagination = JSON.parse(response.headers["X-Pagination"])
        page    = pagination["page"]
        per     = pagination["per"]
        total   = pagination["total"]
        `mkdir -p emails`
        JSON.parse(response.body).each do |email|
          yield(email) if block_given?
        end
      end
    end
    
    def pull_emails handle=nil, *args
      prepare
      old_emails = {}
      get_emails(params: "version:1", notify: "Downloading old") do |email|
        old_emails[email["key"]] = email
      end
      
      get_emails(params: "version:2", notify: "Downloading") do |email|
        email = old_emails[email["key"]] if old_emails[email["key"]]
        
        content  = EMAIL_SPLITTER + "subject: #{email["subject"]}\n" + EMAIL_SPLITTER + email["content_html"].to_s
        File.write("emails/#{email["key"]}.html.liquid", content)
        File.write("emails/#{email["key"]}.text.liquid", email["content_text"])
      end
    end

    def push **args
      prepare
      file = Package.zip

      theme = Faraday::UploadIO.new(file, "application/zip")
      request Pathname.new("api/v1/themes/#{Editor.handle}/upload").cleanpath.to_s, method: :patch, notify: -> { "Uploading #{Editor.handle}" }, body: { zip: theme, reset: args[:reset] } do |faraday|
        faraday.options.timeout = 120
        faraday.headers['Current-Shop'] = Editor["oauth-site"]
      end
    ensure
      Utils.rm_tempfile file
    end
    
    def push_emails **args
      prepare
      html_end = ".html.liquid"
      Dir["emails/*"].each do |file|
        next unless file.end_with?(html_end)
        key    = file.sub(html_end,"").sub("emails/","") # like: "order.confirmation"
        ext_id = nil

        # fetch old one to delete and existing one to update
        get_emails(params: "where=key:#{key}", notify: "Getting info for #{key}") do |email|
          if email["version"] == 1 || email["version"] == 0
            # send to delete
            response = request "api/v1/emails/#{email["id"]}?version=1", method: :delete, notify: -> { "Deleting old" } do |faraday|
              faraday.headers['Current-Shop'] = Editor["oauth-site"]
            end
          else
            ext_id = email["id"]
          end
        end
        
        # update existing one
        if ext_id # patch
          html = File.read("emails/#{key}.html.liquid").split("---\n")
          json = {
            id: ext_id,
            subject: html[1].sub("subject: ","").strip,
            content_text: File.read("emails/#{key}.text.liquid"),
            content_html: html[2],
            translations: {}
          }
          # needed while we have translations and didn't remove them
          %w(en ru et lv).each do |locale|
            json[:translations]["#{locale}.subject"]      = json[:subject]
            json[:translations]["#{locale}.content_html"] = json[:content_html]
            json[:translations]["#{locale}.content_text"] = json[:content_text]
          end
          response = request "api/v1/emails/#{ext_id}?version=2", method: :patch, notify: -> { "Updating #{key}" }, body: {email: json} do |faraday|
            faraday.headers['Current-Shop'] = Editor["oauth-site"]
          end
        else # create
          raise "Email #{key} was removed from DB. Contact helpdesk."
        end
      end
    end

    def zip
      zip_name = "#{Editor.handle}.zip"
      file = Package.zip
      Logger.notify "Writing #{zip_name}" do
        Utils.write_file(zip_name) { file.read }
      end
    end

    def sync resource = nil, opts={}
      prepare

      if resource
        Sync.send(resource)
        Mounter::Model::Base.save
        return
      end

      Sync.products
      Sync.shop
      Sync.images unless opts[:"skip-images"]
      Sync.media_files
      Sync.collections
      Sync.vendors
      Sync.pages
      Sync.menus
      Sync.countries
      Sync.states
      Sync.addresses
      Sync.links
      Sync.blog_posts
      Sync.settings_data
      Sync.customers
      Sync.customer_groups
      Sync.reviews
      Sync.discounts
      Sync.custom_fields
      Sync.subcriptions
      Mounter::Model::Base.save
    end

    def oauth_client
      return @client if defined?(@client)

      @client = OAuth2::Client.new(
        Editor["oauth-client-id"],
        Editor["oauth-client-secret"],
        site: "#{Editor["server"]["protocol"]}://#{Editor["server"]["url"]}",
        token_url: "/api/v1/oauth/token",
        authorize_url: "oauth/authorize?domain=#{Editor["oauth-site"]}"
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

      `rm #{Sequel::Model.db.opts[:database]}`
      Sequel::Model.db= Sequel.sqlite(Sequel::Model.db.opts[:database])
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
      cache = Editor["oauth-cache"]
      OAuth2::AccessToken.new(oauth_client, cache["access_token"], refresh_token: cache["refresh_token"])
    end

    def authorize_url
      oauth_client.auth_code.authorize_url(redirect_uri: Editor["oauth-redirect-uri"], scope: "admin", response_type: "code_and_token")
    end

    def get_authented_token(code)
      oauth_client.auth_code.get_token(code, client_id: oauth_client.id, client_secret: oauth_client.secret, redirect_uri: Editor["oauth-redirect-uri"], scope: "admin", headers: { 'Current-Shop' => Editor["oauth-site"] })
    end

    def access_token
      if have_token?
        get_token
      else
        prepare
        get_token
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
      thread.abort_on_exception = true
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
