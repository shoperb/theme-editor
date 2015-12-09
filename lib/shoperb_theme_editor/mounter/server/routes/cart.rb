module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Cart
          def self.registered(app)
            app.post "/cart/checkout" do
              redirect "/cart"
            end


            app.post "/cart" do
              params[:update].each do |id, amount|
                Model::CartItem.find(id.to_i).tap do |item|
                  item.amount = amount.to_i
                  item.save
                end
              end

              respond_to do |f|
                f.json { respond :cart, params, layout: "" }
                f.html { redirect "/cart" }
              end
            end

            app.post "/cart/add" do
              variant_id = params[:variant].to_i
              amount = params[:amount].to_i

              cart = current_cart

              cart.token ||= SecureRandom.hex(12)

              item = Model::CartItem.where(variant_id: variant_id).first || Model::CartItem.new(variant_id: variant_id)
              item.amount ||= 0
              item.amount += amount

              item.save

              cart.save

              respond_to do |f|
                f.json { respond :cart, params, layout: "" }
                f.html { redirect "/cart" }
              end
            end
          end
        end
      end
    end
  end
end end end
