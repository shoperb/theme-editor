Sinatra.autoload :Flash, "sinatra/flash"

Tilt::Template.class_eval do
  def require_template_library(name)
    # Silence the warning
    require name
  end
end

module Shoperb
  module Mounter
    class Server < Sinatra::Base

      Shoperb.autoload_all self, "shoperb/mounter/server"

      set :root, Dir.pwd
      set :views, Proc.new { File.join(root, "templates") }

      use ExceptionHandler

      enable :sessions

      register Sinatra::Flash
      register Sinatra::RespondWith
      register Routes
      register Assets

      helpers do
        def render_any template, locals={}, registers={}
          Model::Theme.instance.render(template, locals.reverse_merge!(default_locals(locals)), registers.merge(server: self))
        end

        def render_home locals={}
          render_any [:home, :index, :frontpage], locals
        end

        def current_cart
          Model::Cart.instance
        end

        def shop
          Model::Shop.instance
        end

        def default_locals locals
          set_pagination_defaults
          {
            :errors       => Liquid::Drop::Collection.new(flash[:errors]),
            :meta         => Liquid::Drop::Meta.new(locals.delete(:meta)),
            :categories   => Liquid::Drop::Categories.new(Model::Category.all),
            :cart         => current_cart.to_liquid,
            :menus        => Liquid::Drop::Menus.new,
            :pages        => Liquid::Drop::Pages.new,
            :search       => Liquid::Drop::Search.new(params[:query]),
            :shop         => shop.to_liquid,
            :path         => request.path,
            :params       => params,
            :url          => Liquid::Drop::Url::Get.new,
            :form_actions => Liquid::Drop::Url::Post.new,
            :collections  => Liquid::Drop::ProductCollections.new
          }
        end

        def set_pagination_defaults
          params["pagination"] ||= {}
          params["page"] = params["page"].present? ? params["page"].to_i : 1
          params["pagination"]["size"] ||= (1..25).to_a.sample
          min = params["page"] * params["pagination"]["size"].to_i
          params["pagination"]["total"] ||= (min..min+200).to_a.sample
          params["pagination"]["pages"] ||= (params["pagination"]["total"].to_i / params["pagination"]["size"].to_i)
          params["pagination"]["last"] ||= params["pagination"]["total"].to_i - 1
          params["pagination"]["offset"] ||= ((params["page"].to_i - 1) * params["pagination"]["size"].to_i)
        end
      end
    end
  end
end
