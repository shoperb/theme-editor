module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Dummy

          def self.registered(app)

            app.post "/cart/checkout" do
              redirect "/cart"
            end

            cart_response = -> {
              respond_to do |f|
                f.json { respond :cart, params, layout: "" }
                f.html { redirect "/cart" }
              end
            }


            app.post "/cart", &cart_response

            app.post "/cart/add", &cart_response

            app.get "/search" do
              respond :search
            end

          end
        end
      end
    end
  end
end end end
