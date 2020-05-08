module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Cart
          def self.registered(app)
            app.helpers do
              include ::ActionView::Helpers::NumberHelper

              def cart_json
                json = { }

                json[:count] = current_cart.items.count
                json[:total] = number_with_precision(current_cart.total, :precision => 2)
                json[:weight] = number_with_precision(current_cart.weight, :precision => 2)
                json[:requires_shipping] = current_cart.require_shipping?

                json[:items] = current_cart.items.map do |item|
                  {:id                 => item.id,
                    :sku                => item.sku,
                    :name               => item.variant.name,
                    :handle             => item.product.handle,
                    :permalink          => item.product.permalink,
                    :price              => number_with_precision(item.variant.active_price, :precision => 2),
                    :weight             => number_with_precision(item.variant.weight, :precision => 2),
                    :quantity           => item.amount,
                    :total              => number_with_precision(item.total, :precision => 2),
                    :product            => item.product.name,
                    :variant_id         => item.variant.id,
                    :product_id         => item.product.id,
                    :requires_taxing    => item.variant.charge_taxes?,
                    :requires_shipping  => item.variant.require_shipping?,
                    :dimensions         => {
                      :width  => number_with_precision(item.variant.width, :precision => 2),
                      :height => number_with_precision(item.variant.height, :precision => 2),
                      :depth  => number_with_precision(item.variant.depth, :precision => 2)
                    },
                    :attributes => {
                      :product => item.product.product_attributes.map do |attribute|
                        [attribute.handle, { name: attribute.name, value: attribute.value }]
                      end.to_h,
                      :variant => item.variant.variant_attributes.map do |attribute|
                        [attribute.handle, { name: attribute.name, value: attribute.value }]
                      end.to_h
                    }
                  }
                end

                if Array(params[:include]).include?("liquid")
                  json[:liquid] = template_result(:cart, {}, {layout:nil})
                end

                json
              end
            end

            app.post "/cart/checkout" do
              redirect "/cart"
            end

            app.post "/cart/add" do
              by_subscription = %w(1 true).include?(params[:by_subscription])
              variant_id = params[:variant].to_i
              amount = params[:amount].to_i

              cart = current_cart

              cart.token ||= SecureRandom.hex(12)

              item = Model::CartItem.where(variant_id: variant_id, by_subscription: by_subscription).first || Model::CartItem.new(variant_id: variant_id, by_subscription: by_subscription)
              item.amount ||= 0
              item.amount += amount

              item.save
              cart.save

              respond_to do |f|
                f.json { json(cart_json) }
                f.html { redirect "/cart" }
              end
            end

            app.post "/cart/update" do
              cart = current_cart
              params[:update].each do |item, amount|
                item = cart.items.where(id: item.to_i).first
                item.amount = amount.to_i
                item.save
              end
              
              respond_to do |f|
                f.json { json(cart_json) }
                f.html { redirect "/cart" }
              end
            end

            app.post "/cart" do
              params[:update].each do |id, amount|
                Model::CartItem.find(id.to_i).tap do |item|
                  item.amount = amount.to_i
                  item.save
                end
              end

              respond_to do |f|
                f.json { json(cart_json) }
                f.html { redirect "/cart" }
              end
            end
          end
        end
      end
    end
  end
end end end
