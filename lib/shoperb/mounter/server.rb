require "sinatra"
require_relative "./exception_handler"

module Shoperb
  module Mounter
    class Server < Sinatra::Base
      set :root, Dir.pwd
      set :views, Proc.new { File.join(root, "templates") }

      use ExceptionHandler

      enable :sessions

      register Sinatra::Flash
      register Routes
      register Assets

      def liquid template, locals={}
        Theme.instance.render(template, locals.reverse_merge!(default_locals(locals)), {server: self})
      end

      def current_cart
        Cart.instance
      end

      def shop
        Shop.instance
      end

      def default_locals locals
        {
          :errors       => CollectionDrop.new(flash[:errors]),
          :meta         => MetaDrop.new(locals.delete(:meta)),
          :categories   => CategoriesDrop.new(Category.all),
          :cart         => CartDrop.new(current_cart),
          :menus        => MenusDrop.new,
          :pages        => PagesDrop.new,
          :search       => SearchDrop.new(params[:query]),
          :shop         => ShopDrop.new(shop),
          :path         => request.path,
          :params       => params,
          :url          => UrlDrop::Get.new,
          :form_actions => UrlDrop::Post.new,
          :collections  => ProductCollectionsDrop.new
        }
      end
    end
  end
end
