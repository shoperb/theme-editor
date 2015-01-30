require 'open-uri'

module Shoperb module Theme module Editor
  module Sync
    extend self

    Editor.autoload_all self, "sync"

    def vendors
      process Mounter::Model::Vendor
    end

    def collections
      process Mounter::Model::Collection
    end

    def pages
      process Mounter::Model::Page
    end

    def blog_posts
      process Mounter::Model::BlogPost
    end

    def addresses
      process Mounter::Model::Address
    end

    def images
      Images.process
    end

    def menus
      process Mounter::Model::Menu do |hash|
        hash["menu"]
      end
    end

    def links
      process Mounter::Model::Link do |link|
        assign_relation link, Mounter::Model::Menu
        link
      end
    end

    def variants
      process Mounter::Model::Variant do |variant|
        assign_relation variant, Mounter::Model::Product
        variant
      end
    end

    def variant_attributes
      process Mounter::Model::VariantAttribute do |variant_attribute|
        assign_relation variant_attribute, Mounter::Model::Variant
        variant_attribute
      end
    end

    def products
      process Mounter::Model::ProductType, "product-types"
      process Mounter::Model::Category
      process Mounter::Model::Product do |product|
        assign_relation product, Mounter::Model::Category
        assign_relation product, Mounter::Model::ProductType
        product.delete("images")
        product
      end
      product_attributes
      variants
      variant_attributes
    end

    def product_attributes
      process Mounter::Model::ProductAttribute do |product_attribute|
        assign_relation product_attribute, Mounter::Model::Product
        product_attribute
      end
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

    def process klass, path=klass.to_s.demodulize.tableize, &block
      result = fetch(path).map(&(block || ->(this){this}))
      uniq = result.uniq { |h| h[klass.primary_key.to_s] }
      Logger.info "Received #{result.count} #{path.pluralize(result.count)}, kept #{uniq.count}.\n" if Editor["verbose"]
      klass.assign uniq
    end

    def counter
      ->(from, to, total) { "(#{from} to #{to} of #{total})" }
    end

    private

    def fetch path, message="Syncing #{path}"
      records, response, page = [], nil, nil
      Logger.notify message do
        begin
          Logger.info "#{message} #{page.message(&counter)}\r" if page
          records += Array.wrap((response = get_response(path, page)).parsed)
        end while (page = Pagination.new(response).presence)
      end
      records
    end

    def get_response path, page
      Api.access_token.get(path, &as_json(page: page.try(:next_page)))
    end

    def as_json(params={})
      ->(req) {
        req.headers["Accept"] = "application/json"
        req.params = params
      }
    end

    def assign_relation attributes, klass
      name = klass.to_s.demodulize.underscore
      id = attributes["#{name}_id"]
      primary_key = klass.primary_key
      attributes["#{name}_#{primary_key}"] = klass.where(id: id).first.try(primary_key) if id
      attributes["#{name}_#{primary_key}"] || (attributes["#{name}_id"] = id if id)
    end

  end
end end end
