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

          get "/products/:id" do
            product      = ShoperbLiquid::ProductDrop.new(record = Model::Product.find_by(permalink: params[:id]))
            category     = product.category
            template     = record.template.presence || :product
            respond template.to_sym, product: product, category: category, meta: product
          end

          get "/cart" do
            respond :cart
          end

          get "/" do
            respond [:home, :index, :frontpage]
          end

          get "/login" do
            respond :login
          end

          get "/signup" do
            respond :signup
          end

          get "/recover" do
            respond :password_request
          end

          get "/reset" do
            respond :password_change
          end

          get "/account" do
            respond :account
          end

          get "/reset/:token" do
            respond :password_change
          end

          not_found do
            respond :not_found
          end

          get "/brands" do
            respond :brands
          end

          get "/brands/:id" do
            drop = ShoperbLiquid::VendorDrop.new(Model::Vendor.find(params[:id]))
            respond :brand, vendor: drop, brand: drop, meta: drop
          end

          get "/blog" do
            respond :blog_posts, posts: ShoperbLiquid::CollectionDrop.new(Model::BlogPost.active.page(params[:page]).per(20))
          end

          get "/blog/:id" do
            post = Model::BlogPost.find_by(permalink: params[:id])
            template = post.template.presence || :blog_post
            respond template, post: post, meta: post
          end

          get "/addresses/new" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(Model::Address.new)
          end

          post "/addresses" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(Model::Address.new(params[:address]))
          end

          patch "/addresses/:id" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(current_customer.addresses.detect { |address| address.id.to_s == params[:id].to_s })
          end

          put "/addresses/:id" do
            respond :address, address: ShoperbLiquid::AddressDrop.new(current_customer.addresses.detect { |address| address.id.to_s == params[:id].to_s })
          end

          delete "/addresses/:id" do
            redirect_to "/addresses"
          end

          get "/emails/:template" do
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
          resource Model::Category do
            ShoperbLiquid::CategoryDrop.new(request.env[:current_category] = Model::Category.find_by(permalink: params[:id]))
          end

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
          get "/#{name.pluralize}/:id" do
            drop = instance_exec(&block)
            instance_variable_set("@#{name}", drop.record)

            respond name, name => drop, :meta => drop
          end
        end

        def self.resources collection, &block
          name = collection.to_s.demodulize.underscore.pluralize
          get "/#{name}" do
            respond name, name => instance_exec(&block)
          end
        end

      end
    end
  end
end end end
