require 'open-uri'

module Shoperb
  module Sync
    extend self

    Shoperb.autoload_all self, "shoperb/sync"

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
      FileUtils.mkdir_p(dir = Utils.base + "data" + "assets" + "images")
      downloads = []
      process Mounter::Model::Image do |image|
        image["sizes"] = image["sizes"].map do |size, url|
          next unless url
          filename = dir + "#{Pathname.new(url).basename.to_s.split("?")[0]}"
          (downloads << -> { Utils.write_file(filename) { open(url).read } }) unless File.exists?(filename)
          [size, filename.relative_path_from(dir).to_s]
        end.compact.to_h
        image
      end
      threaded_download "Downloading images", downloads
    end

    def menus
      process Mounter::Model::Menu do |hash|
        hash["menu"]
      end
    end

    def links
      process Mounter::Model::Link do |link|
        # todo: TODOREF1
        # assign_relation link, Mounter::Model::Menu
        link["menu_#{Mounter::Model::Menu.primary_key}"] = Mounter::Model::Menu.where(id: link["menu_id"]).first.try(Mounter::Model::Menu.primary_key)
        # todo: TODOREF1 end
        link
      end
    end

    def variants
      process Mounter::Model::Variant do |variant|
        assign_relation variant, Mounter::Model::Product
        variant
      end
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

    private

    def process klass, path=klass.to_s.demodulize.tableize, &block
      klass.assign fetch(path).map(&(block || ->(i){i}))
    end

    def fetch path, message="Syncing #{path}"
      records, response, page = [], nil, nil
      Logger.notify message do
        begin
          Logger.info "#{message} #{page.message(&counter)}\r" if page
          response = OAuth.access_token.get(path, &as_json(page: page.try(:next_page)))
          items = Array.wrap(response.parsed)
          records += items
        end while (page = Pagination.new(response).presence)
      end
      records
    end

    def counter
      ->(from, to, total) { "(#{from} to #{to} of #{total})" }
    end

    def as_json(params={})
      ->(req) {
        req.headers["Accept"] = "application/json"
        req.params = params
      }
    end

    def assign_relation attributes, klass
      name = klass.to_s.demodulize.underscore
      id = attributes.delete("#{name}_id")
      attributes["#{name}_#{klass.primary_key}"] = klass.where(id: id).first.try(klass.primary_key) if id
      attributes["#{name}_#{klass.primary_key}"] || (attributes["#{name}_id"] = id if id)
    end

    def threaded_download message, downloads
      return unless downloads.any?
      Logger.info message
      Logger.notify message do
        current, count = 0, 25
        downloads.each_slice(count) do |dls|
          current = current + count
          Logger.info "#{message} #{counter[current - count, [current, downloads.count].min, downloads.count]}\r"
          dls.map { |block| Thread.new(&block) }.map(&:join)
        end
      end
    end

  end
end
