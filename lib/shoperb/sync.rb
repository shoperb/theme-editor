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
      clean_file "products"
      clean_file "variants"
      clean_file "attributes"
      each_instance "products" do |product_hash|
        Replacer.new("products").replace(product_hash["name"], product_hash) do |attrs|
          attrs.delete("images").each do |item|
            item["product_name"] = product_hash["name"]
            image item
          end
          each_instance "products/#{product_hash["id"]}/variants" do |item|
            item["product_name"] = product_hash["name"]
            variant item
          end
          each_instance "products/#{product_hash["id"]}/attributes" do |item|
            item["product_name"] = product_hash["name"]
            product_attribute item
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

    def variant hash
      Replacer.new("variants").replace(hash["id"], hash, "id")
    end

    def product_attribute hash
      Replacer.new("attributes").replace(hash["name"], hash)
    end

    def vendors
      clean_file "vendors"
      plain_sync "vendors"
    end

    def collections
      clean_file "collections"
      plain_sync "collections"
    end

    def categories
      clean_file "categories"
      plain_sync "categories"
    end

    def pages
      clean_file "pages"
      plain_sync "pages"
    end

    def blog_posts
      clean_file "blog_posts"
      plain_sync "blog_posts"
    end

    def product_types
      clean_file "product_types"
      plain_sync "product-types"
    end

    def languages
      clean_file "languages"
      plain_sync "languages"
    end

    def addresses
      clean_file "addresses"
      plain_sync "addresses", "id"
    end

    def currencies
      clean_file "currencies"
      plain_sync "currencies"
    end

    def images
      clean_file "images"
      each_instance "images", &method(:image)
    end

    def menus
      clean_file "menus"
      clean_file "links"
      each_instance "menus" do |menu_hash|
        menu_hash = menu_hash["menu"]
        menu_hash.delete("errors")
        Replacer.new("menus").replace(menu_hash["name"], menu_hash) do |attrs|
          each_instance "menus/#{attrs["id"]}/links" do |link_hash|
            Replacer.new("links").replace(link_hash["name"], link_hash)
          end
        end
      end
    end

    def shop
      clean_file "shop", {}
      Replacer.new("shop").replace_single OAuth.access_token.get("shop", &as_json).parsed
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
