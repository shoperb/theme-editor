
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

          resource_route(app, Model::Category)
          resource_route(app, Model::Collection)
          resource_route(app, Model::Order)

          app.get "/products" do
            respond :products, products: Drop::Products.new(Model::Product.all)
          end

          app.get "/products/:id" do
            product      = Model::Product.find(params[:id])
            category     = product.category
            template     = product.template.presence || :product

            respond template.to_sym, product: product, category: category, meta: product
          end

          app.get "/orders" do
            respond :orders, orders: Drop::Delegate::Array.new(Model::Order.all)
          end

          app.get "/cart" do
            respond :cart
          end

          app.get "/" do
            respond [:home, :index, :frontpage]
          end

        end

        def self.resource_route app, klass
          const = klass.to_s.demodulize
          name = const.underscore.to_sym
          template = name.to_s.pluralize
          app.get "/#{template}/:id" do
            locals = {}
            item = klass.find(params[:id])
            locals[:meta] = locals[name] = item
            respond(template.to_sym, locals)
          end
        end

      end
    end
  end
end