require 'sinatra'
module Shoperb
  module OAuth
    class Server < Sinatra::Base

      get '/callback' do
        begin
          OAuth.auth_code = params[:code]
          erb :callback
        end
      end

    end
  end
end