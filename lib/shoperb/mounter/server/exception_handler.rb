module Shoperb
  module Mounter
    class Server
      class ExceptionHandler

        def initialize(app)
          @app = app
        end

        def call(env)
          begin
            @app.call env
          rescue Exception => e
            Shoperb::Error.report(e)
            raise e
          end
        end

      end
    end
  end
end