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

        def add_store_account_billing_payment_methods_path(**_)
          "/account/billing/payment-methods/add"
        end

        def store_account_billing_payment_methods_path(**_)
          "/account/billing/payment-methods"
        end

        def store_account_billing_payment_method_path(id, **_)
          "/account/billing/payment-methods/#{id}"
        end

        def delete_store_account_billing_payment_method_path(id, **_)
          "/account/billing/payment-methods/#{id}/delete"
        end

        def store_account_subscriptions_path(**_)
          "/account/subscriptions"
        end

        def store_account_subscription_plans_path(**_)
          "/account/subscriptions/plans"
        end

        def store_account_create_subscription_path(plan_id = nil,**_)
          str  = "/account/subscriptions/create"
          str += "/#{plan_id}" if plan_id
          str
        end

        def store_account_delete_subscription_path(id,**_)
          "/account/subscriptions/#{id}/delete"
        end

        def store_address_path(obj, **_)
          id = get_id(obj)
          "/addresses/#{id}"
        end

        def new_store_address_path(**_)
          "/addresses/new"
        end

        def store_addresses_path(**_)
          "/addresses"
        end


        def delete_store_address_path(id,**_)
          "/addresses/#{id}/delete"
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

        def store_product_url(obj, **_)
          "https://#{shop.domain}/#{Translations.locale}/products/#{get_id(obj)}"
        end

        def reviews_store_product_path(obj, **_)
          "/products/#{get_id(obj)}/reviews"
        end

        def store_products_path(**_)
          "/products"
        end

        def store_variants_path(**_)
          "/variants"
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

        def store_order_returns_path(**_)
          "/order-returns"
        end

        def new_store_order_return_path(**_)
          "/order-returns/new"
        end

        def store_order_return_path(id, **_)
          "/order-returns/#{id}"
        end

        def store_order_return_generate_parcel_path(id, **_)
          "/order-returns/#{id}/generate-parcel"
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
            obj.try(:permalink) || obj.try(:to_param) || obj.try(:id)
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
          if res.try(:start_with?, "http")
            res
          else
            locale = args.symbolize_keys[:locale] || Translations.locale
            "/#{locale}#{res}"
          end
        end
      end
    end
  end
end end end
