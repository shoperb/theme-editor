module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        Editor.autoload_all self, "mounter/server/routes"

        mattr_accessor :app

        class << self
          delegate :register, to: :app
          delegate :get, to: :app
          delegate :post, to: :app
          delegate :patch, to: :app
          delegate :put, to: :app
          delegate :delete, to: :app
          delegate :not_found, to: :app
        end

        def self.registered(app)
          self.app = app

          register_modules
          append_paths

          get "/?:locale?/categories/*" do
            params[:id] = params[:splat][0]
            drop = ShoperbLiquid::CategoryDrop.new(request.env[:current_category] = Model::Category.find_by(permalink: params[:id]))
            @category = drop.record
            respond :category, category: drop, meta: drop
          end

          get "/?:locale?/products/:id" do
            product      = ShoperbLiquid::ProductDrop.new(record = Model::Product.find_by(permalink: params[:id]))
            category     = product.category
            template     = record.template.presence || :product
            respond template.to_sym, product: product, category: category, meta: product
          end

          get "/?:locale?/products/:id/reviews" do
            product  = ShoperbLiquid::ProductDrop.new(record = Model::Product.find_by(permalink: params[:id]))
            category = product.category
            reviews  = product.reviews
            respond :reviews, product: product, category: category, meta: product, reviews: reviews
          end

          get "/?:locale?/cart" do
            respond :cart
          end

          get "/?:locale?/" do
            respond [:home, :index, :frontpage]
          end

          get "/?:locale?/login" do
            respond :login
          end

          post "/?:locale?/login" do
            respond :login
          end

          get "/?:locale?/signup" do
            respond :signup
          end

          get "/?:locale?/recover" do
            respond :password_request
          end

          get "/?:locale?/reset" do
            respond :password_change
          end

          get "/?:locale?/account" do
            respond :account
          end
          
          
          get "/?:locale?/account/billing/payment-methods" do
            meth = ShoperbLiquid::PaymentCardDrop.new(OpenStruct.new(
              id: 1,
              service:"stripe",
              card: {"name"=>nil, "brand"=>"Visa", "last4"=>"4242","country"=>"US", "exp_year"=>2022, "exp_month"=>11, "type"=>"credit"}
            ))
            respond :billing_payment_methods, payment_methods: [meth]
          end
          get "/?:locale?/account/billing/payment-methods/add" do
            meth     = ShoperbLiquid::PaymentCardDrop.new(OpenStruct.new)
            provider = ShoperbLiquid::PaymentProviderDrop.new(OpenStruct.new(
              id: 1,
              name: "Stripe",
              type: "stripe",
              public_key: "pk_test_JqbMzr2NvnK25D5QEEm0OlZg"
            ))
            respond :billing_payment_method, payment_method: meth, providers: [provider]
          end
          post "/?:locale?/account/billing/payment-methods" do # create action
            redirect "/account/billing/payment-methods"
          end
          get "/?:locale?/account/billing/payment-methods/:id" do
            meth = ShoperbLiquid::PaymentCardDrop.new(OpenStruct.new(
              id: params[:id].to_i,
              service:"stripe",
              card: {"name"=>nil, "brand"=>"Visa", "last4"=>"4242","country"=>"US", "exp_year"=>2022, "exp_month"=>11, "type"=>"credit"}
            ))
            respond :billing_payment_method, payment_method: meth
          end
          get "/?:locale?/account/billing/payment-methods/:id/delete" do
            redirect "/account/billing/payment-methods"
          end
          

          get "/?:locale?/reset/:token" do
            respond :password_change
          end

          not_found do
            respond :not_found
          end

          get "/?:locale?/brands" do
            respond :brands
          end

          get "/?:locale?/brands/:id" do
            drop = ShoperbLiquid::VendorDrop.new(Model::Vendor.find(params[:id]))
            respond :brand, vendor: drop, brand: drop, meta: drop
          end

          get "/?:locale?/blog" do
            respond :blog_posts, posts: ShoperbLiquid::CollectionDrop.new(Model::BlogPost.active.page(params[:page]).per(20))
          end

          get "/?:locale?/blog/:id" do
            post = Model::BlogPost.find_by(permalink: params[:id])
            template = post.template.presence || :blog_post
            respond template, post: post, meta: post
          end

          get "/?:locale?/addresses/new" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(Model::Address.new)
          end

          post "/?:locale?/addresses" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(Model::Address.new(params[:address]))
          end

          patch "/?:locale?/addresses/:id" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(current_customer.addresses.detect { |address| address.id.to_s == params[:id].to_s })
          end

          put "/?:locale?/addresses/:id" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(current_customer.addresses.detect { |address| address.id.to_s == params[:id].to_s })
          end

          delete "/?:locale?/addresses/:id" do
            redirect_to "/addresses"
          end

          get "/?:locale?/emails/:template" do
            entities = {}
            order = if params[:order_id]
              Model::Order.find(params[:order_id])
            else
              Model::Order.first
            end
            entities.merge!(order: ShoperbLiquid::OrderDrop.new(order))
            customer = if order
              order.customer
            elsif params[:customer_id]
              Model::Customer.find(params[:order_id])
            else
              Model::Customer.last
            end
            entities.merge!(customer: ShoperbLiquid::CustomerDrop.new(customer))
            respond_email params[:template], entities
          end

          post "/?:locale?/reviews" do
            redirect "/products/#{params['review']['product_id']}"
          end
        end

        private

        def self.register_modules
          register Assets
          register Defaults
          register Locale
          register Pages
          register Cart
          register Search
          register Server::Renderer
        end

        def self.append_paths
          resource Model::Collection do
            ShoperbLiquid::ProductCollectionDrop.new(Model::Collection.find_by(permalink: params[:id]))
          end

          resources Model::Collection do
            ShoperbLiquid::CollectionDrop.new(Model::Collection.all)
          end

          resource Model::Order do
            ShoperbLiquid::OrderDrop.new(Model::Order.find(params[:id]))
          end

          resources Model::Order do
            ShoperbLiquid::CollectionDrop.new(Model::Order.all)
          end

          resources Model::Product do
            ShoperbLiquid::ProductsDrop.new(Model::Product.active)
          end

          resources Model::Address do
            ShoperbLiquid::CollectionDrop.new(current_customer.addresses)
          end

          resource Model::Address do
            ShoperbLiquid::AddressDrop.new(current_customer.addresses.detect { |address| address.id.to_s == params[:id].to_s })
          end
        end

        def self.resource collection, &block
          name = collection.to_s.demodulize.underscore
          get "/?:locale?/#{name.pluralize}/:id" do
            drop = instance_exec(&block)
            instance_variable_set("@#{name}", drop.record)

            respond name, name => drop, :meta => drop
          end
        end

        def self.resources collection, &block
          name = collection.to_s.demodulize.underscore.pluralize
          get "/?:locale?/#{name}" do
            respond name, name => instance_exec(&block)
          end
        end

      end
    end
  end
end end end
