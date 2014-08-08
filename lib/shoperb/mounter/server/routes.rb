module Shoperb
  module Mounter
    class Server
      module Routes
        extend self

        def registered(app)

          set_locale(app)

          resource_route(app, Model::Category)
          resource_route(app, Model::Collection)
          resource_route(app, Model::Order)
          resource_route(app, Model::Page) { |page| page.template.to_sym }

          app.get "/products" do
            products = Model::Product.all
            liquid :products, products: Liquid::Drop::Products.new(products)
          end

          app.get "/products/:id" do
            product      = Model::Product.all.detect { |c| c.id.to_s == params[:id] }
            product_drop = Liquid::Drop::Product.new(product)
            category     = Liquid::Drop::Category.new(product.category)
            template     = product.template.presence || :product

            liquid template, product: product_drop, category: category, meta: product_drop
          end

          app.get "/orders" do
            orders = Model::Order.all
            liquid :orders, orders: orders
          end

          app.get "/cart" do
            liquid :cart
          end

          app.get "/" do
            liquid :frontpage
          end

        end

        def resource_route app, klass, params: {}, template: klass.to_s.underscore.to_sym
          app.get "/#{klass.to_s.underscore.pluralize}/:id" do
            item = klass.all.detect { |i| i.id.to_s == params[:id] }
            drop = Mounter.const_get("Liquid::Drop::#{klass}").new(item)
            params.merge!(klass.to_s.underscore.to_sym => drop)
            params.merge!(:meta => drop)
            liquid((block_given? ? yield(item) : template), params)
          end
        end

        def set_locale app
          app.before "/:locale/*" do
            I18n.locale =
              if Model::Language.all.map(&:code).include?(params[:locale])
                request.path_info = "/" + params[:splat][0]
                params[:locale]
              elsif (shop = Model::Shop.instance) && shop.language_code
                shop.language_code
              end
          end
        end

      end
    end
  end
end