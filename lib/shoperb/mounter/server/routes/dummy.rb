module Shoperb
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
              locals = {}
              locals[:category] = Drop::Category.new(Model::Category.find(params[:categories])) if params[:categories].present?
              respond :search, locals
            end

          end
        end
      end
    end
  end
end