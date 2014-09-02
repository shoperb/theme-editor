module Shoperb
  module Mounter
    module Model
      class Fragment < Abstract::LiquidBase

        def self.matcher
          "_*.{liquid,liquid.haml}"
        end

        def render! context
          parse.render!(context)
        end

        def self.render! name, context
          names = [name].flatten
          instance = nil
          names.each do |current_name|
            instance ||= all.detect { |template| /_#{current_name}.liquid.haml\z/ =~ template.path }
            instance ||= all.detect { |template| /_#{current_name}.liquid\z/ =~ template.path }
          end
          raise Error.new("File not found: _#{name}.liquid(.haml) in #{Utils.rel_path(directory)}") unless instance
          instance.render!(context)
        end

      end
    end
  end
end

