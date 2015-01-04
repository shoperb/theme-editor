module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Base < ActiveYaml::Base

        set_root_path Utils.base + "data"
        include ActiveHash::Associations

        class << self
          def belongs_to_with_auto_key(association_id, options = {})
            klass = klass_for(association_id, options)
            options.reverse_merge!(
              class_name: klass.to_s,
              foreign_key: "#{association_id}_#{klass.primary_key}",
              primary_key: klass.primary_key
            )
            belongs_to_without_auto_key(association_id, options)
          end
          alias_method_chain :belongs_to, :auto_key

          def has_many_with_auto_key(association_id, options = {})
            klass = klass_for(association_id, options)
            options.reverse_merge!(
              class_name: klass.to_s,
              foreign_key: "#{to_s.demodulize.underscore}_#{primary_key}",
            )
            has_many_without_auto_key(association_id, options)
          end
          alias_method_chain :has_many, :auto_key

          def load_path(path)
            File.exists?(path) ? YAML.load_file(path) : []
          end

          def save
            [subclasses, [self]].detect(&:any?).each do |klass|
              Utils.write_file(klass.full_path) { klass.as_hash.to_yaml }
            end
          end

          def klass_for association_id, options
            options.has_key?(:class_name) ? options[:class_name].constantize : parent.const_get(association_id.to_s.classify)
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

          def primary_key
            :id
          end

          def translates *args
            fields :translations
            args.each do |arg|
              define_method arg do
                (translations || {}).fetch("#{Translations.locale}.#{arg}", attributes[arg])
              end
            end
          end
        end

        def to_liquid
          if klass = (Mounter::Drop.const_get(self.class.to_s.demodulize))
            klass.new(self)
          end
        end

        def id
          self.class.primary_key.to_s == "id" ? super : send(self.class.primary_key)
        end
      end
    end
  end
end end end
