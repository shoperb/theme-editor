require 'open-uri'

module Shoperb module Theme module Editor
  module Sync
    extend self

    Editor.autoload_all self, "sync"

    def vendors
      process Mounter::Model::Vendor do |vendor|
        vendor.delete("image")
        vendor
      end
    end

    def collections
      process Mounter::Model::Collection
    end

    def countries
      process Mounter::Model::Country
    end

    def states
      process Mounter::Model::State do |state|
        assign_relation state, Mounter::Model::Country
        state
      end
    end

    def pages
      process Mounter::Model::Page
    end

    def blog_posts
      process Mounter::Model::BlogPost
    end

    def media_files
      process Mounter::Model::MediaFile
    end

    def media_files
      process Mounter::Model::MediaFile
    end

    def addresses(customer_ids)
      process Mounter::Model::Address, where: "type:AddressWarehouse|AddressShop|AddressVendor|AddressSupplier"
      lookup = "type:AddressCustomer"
      if customer_ids.present?
        lookup = "owner_type:Customer,owner_id:#{customer_ids}"
      end
      process Mounter::Model::Address, where: lookup
    end

    def images
      Images.process
    end

    def menus
      process Mounter::Model::Menu
    end

    def links
      process Mounter::Model::Link do |link|
        assign_relation link, Mounter::Model::Menu
        link
      end
    end

    def variants(ids)
      process Mounter::Model::Variant, **product_ids_lookup(ids) do |variant|
        assign_relation variant, Mounter::Model::Product
        variant
      end
    end

    def variant_attributes
      variant_ids = Mounter::Model::Variant.select_map(:id)

      klass  = Mounter::Model::VariantAttribute
      path   = klass.to_s.demodulize.tableize
      opts   = {}
      result = []

      variant_ids.each_slice(50) do |list|
        result += fetch("api/v1/#{path}", **opts).compact
      end
      uniq = result.uniq { |h| h[klass.primary_key.to_s] }
      Logger.info "Received #{result.count} #{path.pluralize(result.count)}, kept #{uniq.count}.\n" if Editor["verbose"]
      klass.assign uniq.map(&:to_hash)
    end

    def products(ids)
      lookup = {}
      lookup = {where: "id:#{ids}"} if ids.present?
      process Mounter::Model::ProductType
      process Mounter::Model::Category
      process Mounter::Model::Product, **lookup do |product|
        assign_relation product, Mounter::Model::Category
        assign_relation product, Mounter::Model::ProductType
        assign_relation product, Mounter::Model::Vendor
        product.delete("images")
        product
      end
      product_attributes(ids)
      variants(ids)
      variant_attributes
    end

    def product_attributes(ids)
      process Mounter::Model::AttributeKey
      process Mounter::Model::ProductAttribute, **product_ids_lookup(ids) do |product_attribute|
        assign_relation product_attribute, Mounter::Model::Product
        product_attribute
      end
    end

    def product_ids_lookup(ids)
      ids ? { where: "product_id:#{ids}" } : {}
    end

    def shop
      process Mounter::Model::Currency
      process Mounter::Model::Language
      process Mounter::Model::Shop, "shop" do |shop|
        assign_relation shop, Mounter::Model::Currency
        assign_relation shop, Mounter::Model::Language
        shop
      end
    end

    def settings_data
      data = get_response "api/v1/themes/#{Editor.handle}/settings_data", page: 1 rescue return

      if data.body.presence
        data = JSON.parse(data.body)
        File.write('config/settings_data.json', JSON.pretty_generate(data))
      end
    end

    def customers(ids)
      lookup = {}
      lookup = {where: "id:#{ids}"} if ids.present?
      process Mounter::Model::Customer, **lookup
    end

    def customer_groups
      process Mounter::Model::CustomerGroup
      #process Mounter::Model::CustomerCustomerGroup
    end

    def reviews
      process Mounter::Model::Review do |review|
        assign_relation review, Mounter::Model::Product
        assign_relation review, Mounter::Model::Customer
        review
      end
    end

    def discounts
      process Mounter::Model::Discount
    end

    def custom_fields
      process Mounter::Model::CustomField
    end

    def subcriptions
      process Mounter::Model::CustomerSubscriptionPlan
      process Mounter::Model::CustomerSubscription
    end

    def process klass, path=klass.to_s.demodulize.tableize, **opts, &block
      result = fetch("api/v1/#{path}", **opts).map(&(block || ->(this){this})).compact
      uniq = result.uniq { |h| h[klass.primary_key.to_s] }
      Logger.info "Received #{result.count} #{path.pluralize(result.count)}, kept #{uniq.count}.\n" if Editor["verbose"]
      klass.assign uniq.map(&:to_hash)
    end

    def counter
      ->(from, to, total) { "(#{from} to #{to} of #{total})" }
    end

    private

    def fetch path, message="Syncing #{path}", **opts
      records, response, page = [], nil, nil
      Logger.notify message do
        begin
          Logger.info "#{message} #{page.message(&counter)}\r" if page
          response = get_response(path, **opts.merge(page: page))
          records += Array.wrap(response.parsed)
        end while (page = Pagination.new(response).presence)
      end
      records
    end

    def get_response path, **opts
      page = opts[:page]
      page = page.try(:next_page)
      opts[:page] = page
      Api.request path, method: :get, &as_json(**opts)
    end

    def as_json(params={})
      ->(req) {
        req.headers["Accept"] = "application/json"
        req.headers['Current-Shop'] = Editor["oauth-site"]
        req.options.timeout = 120
        req.params = params
      }
    end

    def assign_relation attributes, klass
      name = klass.to_s.demodulize.underscore
      id = attributes["#{name}_id"]
      primary_key = klass.primary_key
      # attributes["#{name}_#{primary_key}"] = klass.where(id: id).first.try(primary_key) if id

      # apparently where(id: id) still queries not by ID, but by primary key, so:
      attributes["#{name}_#{primary_key}"] = klass.all.detect { |record| record[:id] == id }.try(primary_key)
      attributes["#{name}_#{primary_key}"] ||= (attributes["#{name}_id"] = id if id)
    end

  end
end end end
