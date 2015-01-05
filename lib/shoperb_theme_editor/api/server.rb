module Shoperb module Theme module Editor
  module Api
    class Server < Sinatra::Base
      get URI(Editor["oauth-redirect-uri"]).path do
        Editor["oauth-cache"] = Api.get_authented_token(params[:code]).to_hash.with_indifferent_access
        erb :callback
      end
    end
  end
end end end
