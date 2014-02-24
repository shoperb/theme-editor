require 'better_errors'
require 'coffee_script'
require 'action_pack'
require 'shoperb/editor/engine'

require 'action_controller'
require 'shoperb/editor/misc/renderer'
require 'shoperb/editor/controllers/application_controller'
Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require lib }

require 'shoperb/editor/listen'
require 'shoperb/editor/server/middleware'
require 'shoperb/editor/server/dynamic_assets'
require 'shoperb/editor/server/timezone'

require 'shoperb/editor/liquid'
require 'shoperb/editor/misc'

module Shoperb::Editor
  class Server

    def initialize(reader, options = {})

      @reader = reader
      @app    = self.create_rack_app(@reader)
      #::Liquid::Template.file_system = File.join('.', 'app', 'templates')
    end

    def call(env)
      env['editor.mounting_point'] = @reader.mounting_point
      @app.call(env)
    end

    protected

    def create_rack_app(reader)
      Rack::Builder.new do
        use DynamicAssets, reader.mounting_point.path
        use Rack::Runtime
        use Rack::MethodOverride
        use ActionDispatch::RequestId
        use ActionDispatch::RemoteIp
        use ActionDispatch::Reloader
        use ActionDispatch::Callbacks
        use ActionDispatch::Flash
        use ActionDispatch::ParamsParser

        run Shoperb::Editor::Engine.routes
      end
    end

  end
end
