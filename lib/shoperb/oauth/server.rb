require 'sinatra'
module Shoperb
  module OAuth
    class Server < Sinatra::Base

      get '/callback' do
        Shoperb.config[:'oauth-cache'] = Hash[OAuth.get_authented_token(params[:code]).to_hash.map{ |k, v| [k.to_s, v] }]
        erb :callback
      end

    end
  end
end