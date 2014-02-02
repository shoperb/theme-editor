require 'better_errors'
require 'coffee_script'
require 'action_pack'

require 'shoperb/editor/listen'
require 'shoperb/editor/server/middleware'
require 'shoperb/editor/server/favicon'
require 'shoperb/editor/server/dynamic_assets'
require 'shoperb/editor/server/logging'
require 'shoperb/editor/server/entry_submission'
require 'shoperb/editor/server/path'
require 'shoperb/editor/server/locale'
require 'shoperb/editor/server/page'
require 'shoperb/editor/server/timezone'
require 'shoperb/editor/server/renderer'

require 'shoperb/editor/liquid'
require 'shoperb/editor/misc'

module Shoperb::Editor
  class Server

    def initialize(reader, options = {})

      @reader = reader
      @app    = self.create_rack_app(@reader)

      BetterErrors.application_root = reader.mounting_point.path
      ::Liquid::Template.file_system = File.join('.', 'app', 'templates')
    end

    def call(env)
      env['editor.mounting_point'] = @reader.mounting_point
      @app.call(env)
    end

    protected

    def create_rack_app(reader)
      Rack::Builder.new do
        use Rack::Lint

        use BetterErrors::MiddlewareWrapper

        use Rack::Session::Cookie, {
          key:          'editor.session',
          path:         '/',
          expire_after: 2592000,
          secret:       'uselessinlocal'
        }

        use ::ActionDispatch::Flash

        use Favicon
        use DynamicAssets, reader.mounting_point.path

        use Logging

        use EntrySubmission

        use Path
        use Locale
        use Timezone

        use Page

        run Renderer.new
      end
    end

  end
end
