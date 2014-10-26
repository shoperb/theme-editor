
module Shoperb
  module Mounter
    class Server
      module Routes
        Shoperb.autoload_all self, "shoperb/mounter/server/routes"

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
            product      = Drop::Product.new(record = Model::Product.find(params[:id]))
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

          not_found do
            respond :not_found
          end
        end

        private

        def self.register_modules
          register Assets
          register Defaults
          register Locale
          register Pages
          register Dummy
          register Server::Renderer
        end

        def self.append_paths
          resource Model::Category do
            Drop::Category.new(Model::Category.find(params[:id]))
          end

          resource Model::Collection do
            Drop::Collection.new(Model::Collection.find(params[:id]))
          end

          resource Model::Order do
            Drop::Order.new(Model::Order.find(params[:id]))
          end

          resources Model::Order do
            Drop::Delegate::Array.new(Model::Order.all)
          end

          resources Model::Product do
            Drop::Products.new(Model::Product.all)
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
end
