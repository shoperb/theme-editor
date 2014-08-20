module Shoperb
  module Sync
    extend self

    class Replacer

      attr_accessor :collection_name, :file

      def initialize name
        self.collection_name = name
        self.file = Utils.base + "data" + "#{name}.yml"
      end

      def replace name, hash
        content = YAML::load(File.read(file).force_encoding("utf-8"))
        (content[collection_name] || {}).delete_if { |i| i["name"] == name }
        yield(hash) if block_given?
        (content[collection_name] ||= []) << hash
        Utils.write_file file do
          content.to_yaml
        end
      end
    end


    %w{products categories images collections vendors}.each do |plural|
      define_method plural do |token|
        token.get(plural).parsed.each { |hash| send(plural.singularize, hash, token) }
      end

      define_method plural.singularize do |hash, token|
        Logger.notify "Syncing #{plural.singularize} named #{hash["name"]}" do
          Replacer.new(plural).replace(hash["name"], hash)
        end
      end
    end

  end
end
