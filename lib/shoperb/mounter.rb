require "sinatra/asset_pipeline"
require "sinatra/flash"
require "active_support/all"
require "liquid"
require "action_view"
require "action_dispatch"
require_relative "./mounter/delegate_array"
require_relative "./mounter/routes"
require_relative "./mounter/assets"
require_relative "./mounter/server"
require_relative "./mounter/models"
require_relative "./mounter/liquid"

I18n.enforce_available_locales = false

module Shoperb
  module Mounter

    def self.start
      instance = Server.new
      Rack::Handler::WEBrick.run(instance,
        :Port => Shoperb.config[:port]
      )
    end

  end
end
