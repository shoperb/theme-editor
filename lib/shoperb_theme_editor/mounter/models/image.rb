module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Image < Base

        fields :id, :entity_id, :entity_type, :name, :sizes

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
        # def self.primary_key
        #   :name
        # end
        # todo: TODOREF2 end

        def self.image_size instance, name, url
          Struct.new(:name, :url) do |klass|
            def klass.method_missing name, *args, &block
              instance.send(name, *args, &block)
            end
          end.new(name, url)
        end

        def entity
          Model.const_get(entity_type).all.detect { |obj| obj.attributes[:id] == entity_id }
        end

        def image_sizes
          sizes.map { |name, url| self.class.image_size(self, name, "/#{Shop.first.domain}/images/#{id}/#{url}")}
        end
      end
    end
  end
end end end
