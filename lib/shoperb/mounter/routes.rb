module Shoperb
  module Mounter
    module Routes
      def self.registered(app)

        set_locale(app)

        resource_route(app, ::Category)
        resource_route(app, ::Collection)
        resource_route(app, ::Order)
        resource_route(app, ::Page) { |page| page.template.to_sym }

        app.get "/products" do
          products = Product.all
          liquid :products, products: ProductsDrop.new(products)
        end

        app.get "/products/:id" do
          product      = Product.all.detect { |c| c.id.to_s == params[:id] }
          product_drop = ProductDrop.new(product)
          category     = CategoryDrop.new(product.category)
          template     = product.template.presence || :product

          liquid template, product: product_drop, category: category, meta: product_drop
        end

        app.get "/orders" do
          orders = Order.all
          liquid :orders, orders: orders
        end

        app.get "/cart" do
          liquid :cart
        end

        app.get "/" do
          liquid :frontpage
        end

      end

      def self.resource_route app, klass, params: {}, template: klass.to_s.underscore.to_sym
        app.get "/#{klass.to_s.underscore.pluralize}/:id" do
          item = klass.all.detect { |i| i.id.to_s == params[:id] }
          drop = "#{klass}Drop".constantize.new(item)
          params.merge!(klass.to_s.underscore.to_sym => drop)
          params.merge!(:meta => drop)
          liquid((block_given? ? yield(item) : template), params)
        end
      end

      def self.set_locale app
        app.before "/:locale/*" do
          I18n.locale =
            if Language.all.map(&:code).include?(params[:locale])
              request.path_info = "/" + params[:splat][0]
              params[:locale]
            elsif (shop = Shop.instance) && shop.language_code
              shop.language_code
            end
        end
      end
    end
  end
end