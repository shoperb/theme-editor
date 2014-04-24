module Shoperb
  module Editor
    module Routes
      def self.registered(app)
        app.before '/:locale/*' do
          I18n.locale =
              if Language.all.map(&:code).include?(params[:locale])
                request.path_info = '/' + params[:splat][0]
                params[:locale]
              elsif (shop = Shop.instance) && shop.language_code
                shop.language_code
              end
        end

        app.get '/categories/:id' do
          category = Category.all.detect { |c| c.id.to_s == params[:id] }
          liquid :category, category: category, meta: category
        end

        app.get '/collections/:id' do
          collection = Collection.all.detect { |c| c.id.to_s == params[:id] }
          liquid :collection, collection: collection, meta: collection
        end

        app.get '/orders/:id' do
          order = Order.all.detect { |c| c.id.to_s == params[:id] }
          liquid :order, order: order
        end

        app.get '/pages/:id' do
          page = Page.all.detect { |c| c.id.to_s == params[:id] }
          liquid page.template.to_sym, page: page, meta: page
        end

        app.get '/products' do
          products = Product.all
          liquid :products, products: ProductsDrop.new(products)
        end

        app.get '/products/:id' do
          product      = Product.all.detect { |c| c.id.to_s == params[:id] }
          product_drop = ProductDrop.new(product)
          category     = CategoryDrop.new(product.category)
          template     = product.template.presence || :product

          liquid template, product: product_drop, category: category, meta: product_drop
        end

        app.get '/orders' do
          orders = Order.all
          liquid :orders, orders: orders
        end

        app.get '/cart' do
          liquid :cart
        end

        app.get '/' do
          liquid :index
        end

      end
    end
  end
end