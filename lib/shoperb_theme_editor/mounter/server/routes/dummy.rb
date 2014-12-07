module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Dummy

          def self.registered(app)

            app.post "/cart/checkout" do
              redirect "/cart"
            end

            app.post "/cart" do
              respond_to do |f|
                f.json { respond :cart, params, layout: "" }
                f.html { redirect "/cart" }
              end
            end

            app.post "/cart/add" do
              respond_to do |f|
                f.json { respond :cart, params, layout: "" }
                f.html { redirect "/cart" }
              end
            end

            app.get "/search" do
              respond :search
            end

          end
        end
      end
    end
  end
end end end
