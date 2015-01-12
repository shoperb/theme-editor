module Shoperb module Theme module Liquid module Drop
  module Url
    class Get< ::Liquid::Drop

      def products
        "/products"
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
