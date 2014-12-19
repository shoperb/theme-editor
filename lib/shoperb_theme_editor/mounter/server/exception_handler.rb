module Shoperb module Theme module Editor
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
            Error.report(e)
            raise e
          end
        end

      end
    end
  end
end end end
