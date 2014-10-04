module Shoperb
  module Mounter
    module Model
      class Base < ActiveYaml::Base

        set_root_path Utils.base + "data"
        include ActiveHash::Associations

        class << self
          def load_path(path)
            File.exists?(path) ? YAML.load_file(path) : []
          end

          def save
            [subclasses, [self]].detect(&:any?).each do |klass|
              Utils.write_file(klass.full_path) { klass.as_hash.to_yaml }
            end
          end

          def load_file
            raw_data || []
          end

          def filename
            name.demodulize.tableize
          end

          def as_hash
            all.map(&:attributes).map(&:stringify_keys)
          end

          def assign records
            self.delete_all
            self.data = records.map(&method(:filtered_attributes))
            records
          end

          def filtered_attributes attributes
            attributes.slice(*field_names.map(&:to_s))
          end

          def multiple_files?
            false
          end
        end

        def to_liquid
          if klass = (Mounter::Drop.const_get(self.class.to_s.demodulize))
            klass.new(self)
          end
        end

        def id
          self.class.primary_key == "id" ? super : send(self.class.primary_key)
        end
      end
    end
  end
end

