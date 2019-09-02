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
            respond :billing_payment_methods, payment_methods: [Model::PaymentCard.first.to_liquid]
          end
          get "/?:locale?/account/billing/payment-methods/add" do
            meth     = Model::PaymentCard.new.to_liquid
            provider = Model::PaymentProvider.first.to_liquid
            respond :billing_payment_method, payment_method: meth, providers: [provider]
          end
          post "/?:locale?/account/billing/payment-methods" do # create action
            redirect "/account/billing/payment-methods"
          end
          get "/?:locale?/account/billing/payment-methods/:id" do
            respond :billing_payment_method, payment_method: Model::PaymentCard.first.to_liquid
          end
          get "/?:locale?/account/billing/payment-methods/:id/delete" do
            redirect "/account/billing/payment-methods"
          end
          
          get "/?:locale?/account/subscriptions" do
            respond :billing_subscriptions, subscriptions: ShoperbLiquid::CollectionDrop.new(Model::CustomerSubscription.all.map{|e| ShoperbLiquid::SubscriptionDrop.new(e)})
          end
          get "/?:locale?/account/subscriptions/plans" do
            respond :billing_subscription_plans, subscription: ShoperbLiquid::Subscription.new(Model::CustomerSubscription.all.detect(&:active?))
          end
          get "/?:locale?/account/subscriptions/create/?:plan_id?" do
            subscription = Model::CustomerSubscription.new
            subscription.plan_id       = params[:plan_id]
            subscription.instance_variable_set(:@attributes, 
              subscription.attributes.merge(params.fetch(:subscription,{}).slice(:qty))
            )
            subscription.customer      = current_customer

            flash[:notice] = "subscription.error_occured"
            respond :billing_subscription, subscription: subscription, payment_methods: [Model::PaymentCard.first], providers: [Model::PaymentProvider.first.to_liquid]
          end
          get "/?:locale?/account/subscriptions/:id/delete" do
            flash[:notice] = "subscription.deleted"
            redirect_to "/account/subscriptions/plans"
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
          
          get "/?:locale?/order-returns" do
            respond :order_returns, order_returns: ShoperbLiquid::CollectionDrop.new(Model::OrderReturn.all)
          end
          post "/?:locale?/order-returns" do
            redirect "/order-returns"
          end
          get "/?:locale?/order-returns/new" do
            respond :order_return, order_return: Model::OrderReturn.new.to_liquid, orders: ShoperbLiquid::CollectionDrop.new(Model::Order.per(10))
          end
          get "/?:locale?/order-returns/:id" do
            respond :order_return, order_return: Model::OrderReturn.find(params[:id])&.to_liquid
          end
          post "/?:locale?/order-returns/:id/generate-parcel" do
            respond :order_return, order_return: Model::OrderReturn.find(params[:id])&.to_liquid
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

          get "/?:locale?/emails" do
            out  = "<p>You have next templates:</p>"
            out += "<ul>"
            Dir["emails/*"].each do |file|
              url  = file.sub(".liquid","")
              out += %Q{<li><a href="#{url}">#{url}</a></li>}
            end
            out + "</ul>"
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
            tpl = params[:template]
            
            content_type "text/plain" if tpl.end_with?(".text")
            respond_email tpl, entities
          end

          post "/?:locale?/reviews" do
            redirect "/products/#{params['review']['product_id']}"
          end
          
          append_paths
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
