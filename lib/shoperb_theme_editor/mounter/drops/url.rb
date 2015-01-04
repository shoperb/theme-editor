module Shoperb module Theme module Editor
  module Mounter
    module Drop
      module Url
        class Get< ::Liquid::Drop

          def method_missing(name, *args, &block)
            class_eval do
              url = "/#{name}"
              define_method name do |*args, &block|
                url
              end
            end
            send(name, *args, &block)
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
    end
  end
end end end
