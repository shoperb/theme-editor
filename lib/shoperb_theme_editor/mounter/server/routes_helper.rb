module Shoperb module Theme module Editor
  module Mounter
    class Server
      module RoutesHelper
        extend self

        def store_root_path(**_)
          "/"
        end

        def store_signup_path(**_)
          "/signup"
        end

        def store_login_path(**_)
          "/login"
        end

        def store_new_login_path(**_)
          "/login"
        end

        def store_logout_path(**_)
          "/logout"
        end

        def store_recover_password_path(**_)
          "/recover"
        end

        def store_new_recover_password_path(**_)
          "/recover"
        end

        def store_reset_password_path(**_)
          "/reset"
        end

        def store_upd_reset_password_path(**_)
          "/reset"
        end

        def store_account_path(**_)
          "/account"
        end

        def store_address_path(obj, **_)
          id = get_id(obj)
          "/address/#{id}"
        end

        def store_addresses_path(**_)
          "/addresses"
        end

        def store_brand_path(obj, **_)
          id = get_id(obj)
          "/brands/#{id}"
        end

        def store_brands_path(**_)
          "/brands"
        end

        def store_category_path(obj, **_)
          id = get_id(obj)
          "/categories/#{id}"
        end

        def store_categories_path(**_)
          "/categories"
        end

        def store_checkout_order_url(obj, **_)
          id = get_id(obj)
          "/checkout/#{id}"
        end

        def store_collection_path(obj, **_)
          id = get_id(obj)
          "/collections/#{id}"
        end

        def store_collections_path(**_)
          "/collections"
        end

        def store_order_path(obj, **_)
          id = get_id(obj)
          "/orders/#{id}"
        end

        def store_orders_path(**_)
          "/orders"
        end

        def store_page_path(obj, **_)
          id = get_id(obj)
          "/pages/#{id}"
        end

        def store_pages_path(**_)
          "/pages"
        end

        def store_product_path(obj, **_)
          id = get_id(obj)
          "/products/#{id}"
        end

        def reviews_store_product_path(obj, **_)
          "/products/#{get_id(obj)}/reviews"
        end

        def store_products_path(**_)
          "/products"
        end

        def store_reviews_path(**_)
          "/reviews"
        end

        def store_subscribers_add_path(**_)
          "/subscribers/add"
        end

        def store_search_path(**_)
          "/search"
        end

        def store_blog_post_path(obj, **_)
          id = get_id(obj)
          "/blog/#{id}"
        end

        def store_blog_posts_path(**_)
          "/blog"
        end

        def store_cart_path(**_)
          "/cart"
        end

        def add_store_cart_path(**_)
          "/cart/add"
        end

        def update_store_cart_path(**_)
          "/cart/update"
        end

        def checkout_store_cart_path(**_)
          "/cart/checkout"
        end

        def recognize_path(**args)
          url_for(**args)
        end

        def url_for(**args)
        end

        private

        def get_id(obj)
          case obj
          when Numeric then obj
          when String then obj
          when NilClass then raise StandardError.new("missing argument for building path")
          else
            obj.try(:to_param) || obj.try(:id)
          end
        end

        def self.after(*names)
          names.each do |name|
            m = instance_method(name)
            define_method(name) do |*args, &block|
              res = m.bind(self).(*args, &block)
              yield(res, *args)
            end
          end
        end

        after(*instance_methods) do |res, **args|
          locale = args.symbolize_keys[:locale] || Translations.locale
          "/#{locale}#{res}"
        end
      end
    end
  end
end end end
