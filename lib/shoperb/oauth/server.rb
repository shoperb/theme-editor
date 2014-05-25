require 'sinatra'
module Shoperb
  module OAuth
    class Server < Sinatra::Base

      get URI(Shoperb.config['oauth-redirect-uri']).path do
        Shoperb.config['oauth-cache'] = OAuth.get_authented_token(params[:code]).to_hash.with_indifferent_access
        erb :callback
      end

    end
  end
end