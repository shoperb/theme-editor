module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        Editor.autoload_all self, "mounter/server/routes"

        mattr_accessor :app

        class << self
          delegate :register, to: :app
          delegate :get, to: :app
          delegate :not_found, to: :app
        end

        def self.registered(app)
          self.app = app

          register_modules
          append_paths

          get "/products/:id" do
            product      = Liquid::Drop::Product.new(record = Model::Product.find(params[:id]))
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

          get "/blog" do
            respond :blog_posts, posts: Liquid::Drop::Collection.new(Kaminari::PaginatableArray.new(Model::BlogPost.all).page(params[:page]))
          end

          get "/blog/:id" do
            post = Model::BlogPost.find(params[:id])
            template = post.template.presence || :blog_post
            respond template, post: post, meta: post
          end

          get "/emails/:template" do
            entities = {}
            order = if params[:order_id]
              Model::Order.find(params[:order_id])
            else
              Model::Order.first
            end
            entities.merge!(order: Liquid::Drop::Order.new(order))
            customer = if order
              order.customer
            elsif params[:customer_id]
              Model::Customer.find(params[:order_id])
            else
              Model::Customer.last
            end
            entities.merge!(customer: Liquid::Drop::Customer.new(customer))
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
            Liquid::Drop::Category.new(request.env[:current_category] = Model::Category.find(params[:id]))
          end

          resource Model::Collection do
            Model::Collection.find(params[:id])
          end

          resource Model::Order do
            Liquid::Drop::Order.new(Model::Order.find(params[:id]))
          end

          resources Model::Order do
            Liquid::Drop::Collection.new(Model::Order.all)
          end

          resources Model::Product do
            Liquid::Drop::Products.new(Model::Product.all)
          end
        end

        def self.resource collection, &block
          name = collection.to_s.demodulize.underscore
          get "/#{name.pluralize}/:id" do
            drop = instance_exec(&block)
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
