module Shoperb module Theme module Liquid module Drop
  module Url
    class Get< ::Liquid::Drop

      def products
        "/products"
      end

      def blog
        "/blog"
      end

      def cart
        "/cart"
      end


      def login
        "/login"
      end


      def logout
        "/logout"
      end


      def recover
        "/recover"
      end

      def reset
        "/reset"
      end


      def orders
        "/orders"
      end

      def current_url
        controller.request.url
      end

      def current_path
        controller.request.path
      end

      def current_host
        controller.request.host
      end

      private

      def controller
        @context.registers[:controller]
      end

    end

    class Post < ::Liquid::Drop

      def cart_add
        "/cart/add"
      end

      def cart_checkout
        "/cart/checkout"
      end

      def cart_update
        "/cart"
      end

      def new_login
        "/login"
      end

      def auth_input
        ""
      end
    end
  end
end end end end
