module Shoperb
  module Editor
    class Server < Sinatra::Base
      register Routes
      register Assets
      register Sinatra::Reloader

      def render_liquid template, options
        options.reverse_merge!(shoperb_default_assigns)
        self.response = Theme.instance.render(template, options)
      end

      def shoperb_default_assigns
        {
          :search       => SearchDrop.new(request.params[:query]),
          :menus        => MenusDrop.new,
          :pages        => PagesDrop.new,
          :categories   => CategoriesDrop.new(Category.all),
          :shop         => ShopDrop.new(Shop.instance),
          :cart         => CartDrop.new(Cart.instance),
          :path         => request.path,
          :params       => request.params,
          :orders       => CollectionDrop.new(Order.all),
          :order        => OrderDrop.new(Order.all.first),
          :order_items  => CollectionDrop.new(OrderItem.all)
        }.stringify_keys
      end
    end
  end
end