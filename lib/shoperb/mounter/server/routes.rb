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
            render_any :products, products: Liquid::Drop::Products.new(products)
          end

          app.get "/products/:id" do
            product      = Model::Product.find(params[:id])
            product_drop = Liquid::Drop::Product.new(product)
            category     = Liquid::Drop::Category.new(product.category)
            template     = product.template.presence || :product

            render_any template, product: product_drop, category: category, meta: product_drop
          end

          app.get "/orders" do
            orders = Model::Order.all
            render_any :orders, orders: orders
          end

          app.get "/cart" do
            render_any :cart
          end

          app.get "/" do
            render_any :frontpage
          end

          app.get "/search" do
            params.merge!(:category => Liquid::Drop::Category.new(Model::Category.find(params[:categories]))) if params[:categories].present?
            render_any :search, params
          end

        end

        def resource_route app, klass, template: klass.to_s.demodulize.underscore
          app.get "/#{template.pluralize}/:id" do
            item = klass.find(params[:id])
            drop = Mounter.const_get("Liquid::Drop::#{klass.to_s.demodulize}").new(item)
            params.merge!(template.to_sym => drop)
            params.merge!(:meta => drop)
            render_any((block_given? ? yield(item) : template), params)
          end
        end

        def set_locale app
          app.before "/?:locale/?*" do
            Liquid::Filter::Translate.locale =
              if Liquid::Filter::Translate.all_translations.keys.include?(params[:locale])
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