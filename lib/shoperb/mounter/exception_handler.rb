module Shoperb
  module Mounter
    class ExceptionHandler
      def initialize(app)
        @app = app
      end

      def call(env)
        begin
          @app.call env
        rescue => e
          Rollbar.report_exception(e)
          raise e
        end
      end
    end
  end
end