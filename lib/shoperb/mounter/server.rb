Sinatra.autoload :Flash, "sinatra/flash"

module Shoperb
  module Mounter
    class Server < Sinatra::Base

      Shoperb.autoload_all self, "shoperb/mounter/server"

      set :root, Dir.pwd
      set :views, Proc.new { File.join(root, "templates") }

      use ExceptionHandler

      enable :sessions

      register Sinatra::Flash
      register Routes
      register Assets

      def liquid template, locals={}
        Model::Theme.instance.render(template, locals.reverse_merge!(default_locals(locals)), {server: self})
      end

      def current_cart
        Model::Cart.instance
      end

      def shop
        Model::Shop.instance
      end

      def default_locals locals
        {
          :errors       => Liquid::Drop::Collection.new(flash[:errors]),
          :meta         => Liquid::Drop::Meta.new(locals.delete(:meta)),
          :categories   => Liquid::Drop::Categories.new(Model::Category.all),
          :cart         => Liquid::Drop::Cart.new(current_cart),
          :menus        => Liquid::Drop::Menus.new,
          :pages        => Liquid::Drop::Pages.new,
          :search       => Liquid::Drop::Search.new(params[:query]),
          :shop         => Liquid::Drop::Shop.new(shop),
          :path         => request.path,
          :params       => params,
          :url          => Liquid::Drop::Url::Get.new,
          :form_actions => Liquid::Drop::Url::Post.new,
          :collections  => Liquid::Drop::ProductCollections.new
        }
      end

    end
  end
end
