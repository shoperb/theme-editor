
module Shoperb
  module Mounter
    class Server
      module Routes

        Shoperb.autoload_all self, "shoperb/mounter/server/routes"

        def self.registered(app)

          app.enable :sessions

          app.register Assets
          app.register Defaults
          app.register Locale
          app.register Pages
          app.register Dummy
          app.register Server::Renderer

          app.get "/categories/:id" do
            respond :category, category: Drop::Category.new(Model::Category.find(params[:id]))
          end

          app.get "/collections/:id" do
            respond :collection, collection: Drop::Collection.new(Model::Collection.find(params[:id]))
          end

          app.get "/orders" do
            respond :orders, orders: Drop::Delegate::Array.new(Model::Order.all)
          end

          app.get "/orders/:id" do
            respond :order, order: Drop::Order.new(Model::Order.find(params[:id]))
          end

          app.get "/products" do
            respond :products, products: Drop::Products.new(Model::Product.all)
          end

          app.get "/products/:id" do
            product      = Drop::Product.new(Model::Product.find(params[:id]))
            category     = product.category
            template     = product.template.presence || :product
            respond template.to_sym, product: product, category: category, meta: product
          end


          app.get "/cart" do
            respond :cart
          end

          app.get "/" do
            respond [:home, :index, :frontpage]
          end

        end

      end
    end
  end
end