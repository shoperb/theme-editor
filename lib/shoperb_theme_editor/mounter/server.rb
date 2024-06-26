Sinatra.autoload :Flash, "sinatra/flash"
Sinatra.autoload :RespondWith,"sinatra/respond_with"

Tilt::Template.class_eval do
  def require_template_library(name)
    # Silence the warning
    require name
  end
end

module Shoperb module Theme module Editor
  module Mounter
    class Server < Sinatra::Base
      Editor.autoload_all self, "mounter/server"

      include Server::RoutesHelper

      set :root, Dir.pwd
      set :environment, :development

      use ExceptionHandler
      register Renderer
      register Routes

      helpers do
        def current_cart
          Model::Cart.first || Model::Cart.new
        end

        def current_carts
          current_cart.id ? Model::Cart.all : []
        end

        def shop
          Model::Shop.first || raise(Error.new("No data has been synced."))
        end

        def current_customer
          if (id = params[:customer_id].to_i) > 0
            Model::Customer.find(id: id)
          else
            Model::Customer.first || Model::Customer.new(first_name: "No customer", last_name: "in customers.yml")
          end
        end

        def current_settings
          Editor.theme_settings
        end

        # so far in liquid it's used to replace locale only
        # theme setting link, but we will skip it for now.
        # just minimum required implementation.
        def url_for(*args_main, **args)
          args_main.each do |arg|
            arg.each{|k,v| args[k] = v}
          end
          request.fullpath.gsub(/\A(?=#{shop.all_languages.map{|s|"/#{s}"}.join("|")}|)\/(.*)/, "/#{args[:locale]}/\\1") if args[:locale]
        end

        def form_authenticity_token
          "token"
        end
      end
    end
  end
end end end
