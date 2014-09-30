require 'open-uri'

module Shoperb
  module Sync
    extend self

    class Replacer

      attr_accessor :collection_name, :file

      def initialize name
        self.collection_name = name
        self.file = Utils.base + "data" + "#{name}.yml"
      end

      def current_content
        File.exists?(file) ? File.read(file).force_encoding("utf-8") : ""
      end

      def replace name, hash, var = "name"
        content = YAML::load(current_content) || {}
        (content[collection_name] || {}).delete_if { |i| i[var] == name }
        yield(hash) if block_given?
        (content[collection_name] ||= []) << hash
        Utils.write_file file do
          content.to_yaml
        end
      end

      def replace_single hash
        Utils.write_file file do
          hash.to_yaml
        end
      end
    end

    def products
      product_types
      Logger.notify "Syncing products, variants, attributes & product images" do
        clean_file "products"
        clean_file "variants"
        clean_file "attributes"
        each_instance "products" do |product_hash|
          pt_id = product_hash["product_type_id"]
          category_id = product_hash["category_id"]
          product_hash["category_name"] = Mounter::Model::Category.all.detect { |ct| ct.to_h[:id] == category_id }.try(:name) if category_id
          product_hash["product_type_handle"] = Mounter::Model::ProductType.all.detect { |pt| pt.to_h[:id] == pt_id }.try(:handle) if pt_id
          Replacer.new("products").replace(product_hash["name"], product_hash) do |attrs|
            id = attrs["permalink"]
            rel_name = "product_permalink"
            attrs.delete("images").each do |item|
              item[rel_name] = id
              image item
            end
            each_instance "products/#{attrs["id"]}/variants" do |item|
              item.delete("product_id")
              item[rel_name] = id
              Replacer.new("variants").replace(item["id"], item, "id")
            end
            each_instance "products/#{attrs["id"]}/attributes" do |item|

              item[rel_name] = id
              Replacer.new("attributes").replace(item["name"], item)
            end
          end
        end
      end
    end

    def image hash
      FileUtils.mkdir_p(dir = Utils.base + "data" + "assets" + "images")
      hash["sizes"] = hash["sizes"].map do |size, url|
        next unless url
        filename = dir + "#{hash["name"]}_#{size}#{Pathname.new(url).extname.split("?")[0]}"
        Utils.write_file(filename) { open(url).read } unless File.exists?(filename)
        [size, filename.relative_path_from(dir).to_s]
      end.compact.to_h
      Replacer.new("images").replace(hash["name"], hash)
    end

    def vendors
      Logger.notify "Syncing vendors" do
        clean_file "vendors"
        plain_sync "vendors"
      end
    end

    def collections
      Logger.notify "Syncing collections" do
        clean_file "collections"
        plain_sync "collections"
      end
    end

    def categories
      Logger.notify "Syncing categories" do
        clean_file "categories"
        plain_sync "categories"
      end
    end

    def pages
      Logger.notify "Syncing pages" do
        clean_file "pages"
        plain_sync "pages"
      end
    end

    def blog_posts
      Logger.notify "Syncing blog posts" do
        clean_file "blog_posts"
        plain_sync "blog_posts"
      end
    end

    def product_types
      Logger.notify "Syncing product types" do
        clean_file "product_types"
        plain_sync "product-types"
      end
    end

    def languages
      Logger.notify "Syncing languages" do
        clean_file "languages"
        plain_sync "languages"
      end
    end

    def addresses
      Logger.notify "Syncing addresses" do
        clean_file "addresses"
        plain_sync "addresses", "id"
      end
    end

    def currencies
      Logger.notify "Syncing currencies" do
        clean_file "currencies"
        plain_sync "currencies"
      end
    end

    def images
      Logger.notify "Syncing images" do
        clean_file "images"
        each_instance "images", &method(:image)
      end
    end

    def menus
      Logger.notify "Syncing menus & links" do
        clean_file "menus"
        clean_file "links"
        each_instance "menus" do |menu_hash|
          menu_hash = menu_hash["menu"]
          menu_hash.delete("errors")
          Replacer.new("menus").replace(menu_hash["name"], menu_hash) do |attrs|
            each_instance "menus/#{attrs["id"]}/links" do |link_hash|
              link_hash["menu_handle"] = menu_hash["handle"]
              Replacer.new("links").replace(link_hash["name"], link_hash)
            end
          end
        end
      end
    end

    def shop
      currencies
      languages
      Logger.notify "Syncing shop" do
        clean_file "shop", {}
        attrs = OAuth.access_token.get("shop", &as_json).parsed
        c_id = attrs.delete("currency_id")
        l_id = attrs.delete("language_id")
        attrs.delete("account_id")
        attrs.delete("id")
        attrs["currency_name"] = Mounter::Model::Currency.all.detect { |currency| currency.to_h[:id] == c_id }.try(:name)
        attrs["language_code"] = Mounter::Model::Language.all.detect { |language| language.to_h[:id] == l_id }.try(:code)
        Replacer.new("shop").replace_single attrs
      end
    end

    private

    def clean_file name, content=[]
      path = Pathname.new("data") + "#{name}.yml"
      Utils.write_file(path) {
        { name.pluralize => content }.to_yaml
      } if File.exists?(path)
    end

    def plain_sync plural, name="name"
      each_instance plural do |item_hash|
        Replacer.new(plural.underscore).replace(item_hash[name], item_hash, name)
      end
    end

    def each_instance path, &block
      begin
        page = (page || 0) + 1
        response = OAuth.access_token.get(path, &as_json(page: page))
        items = response.parsed
        items.each { |item| item.delete("shop_id") }
        items.each(&block)
      end while (limit = response.headers["x-limit"].presence) && limit.to_i == items.count
    end

    def as_json(params={})
      ->(req) {
        req.headers["Accept"] = "application/json"
        req.params = params
      }
    end

  end
end
