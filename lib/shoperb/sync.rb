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

      def replace name, hash
        content = YAML::load(current_content) || {}
        (content[collection_name] || {}).delete_if { |i| i["name"] == name }
        yield(hash) if block_given?
        (content[collection_name] ||= []) << hash
        Utils.write_file file do
          content.to_yaml
        end
      end
    end

    def image hash, token
      Utils.mkdir(dir = Utils.base + "data" + "assets" + "images")
      hash["sizes"] = hash["sizes"].map do |size, url|
        next unless url
        filename = dir + "#{hash["name"]}_#{size}#{Pathname.new(url).extname.split("?")[0]}"
        Utils.write_file(filename) { open(url).read } unless File.exists?(filename)
        [size, filename.relative_path_from(dir).to_s]
      end.compact.to_h
      Replacer.new("images").replace(hash["name"], hash)
    end

    %w{products categories collections vendors}.each do |plural|
      define_method plural do |token|
        begin
          page = (page || 0) + 1
          response = token.get("#{plural}?page=#{page}")
          items = response.parsed
          items.each { |hash| send(plural.singularize, hash, token) }
        end while (limit = response.headers["x-limit"].presence) && limit.to_i == items.count
      end

      define_method plural.singularize do |hash, token|
        Replacer.new(plural).replace(hash["name"], hash) do |item|
          item.delete_if { |key,value|
            value.map { |sub_item|
              sub_item["#{plural.singularize}_name"] = hash["name"]
              Sync.send(key.singularize, sub_item, token)
            } if value.is_a?(Array) && value.none?{|v|!v.is_a?(Hash)}
          }
        end
      end
    end

  end
end
