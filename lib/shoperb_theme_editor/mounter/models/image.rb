module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Image < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :entity_id, :entity_type, :name,
               :url, :original_width, :original_height
        c_fields :sizes, cast: JSON

        def self.sorted
          self
        end

        dataset_module do
          def for(obj)
            where(entity_type: obj.class.name.split("::")[-1], entity_id: obj.id)
          end
        end

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
          @entity ||= (Model.const_get(entity_type, false) rescue nil).try { |klass|
            klass.all.detect { |obj| obj.attributes[:id] == entity_id }
          }
        end

        def image_sizes
          @image_sizes ||= sizes.map do |name, url|
            self.class.image_size(self, name, "/#{Editor["oauth-site"]}/images/#{id}/#{url}")
          end
        end
      end
    end
  end
end end end
