module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Search

          def self.registered(app)

            app.get "/search" do
              respond :search
            end

          end
        end
      end
    end
  end
end end end
