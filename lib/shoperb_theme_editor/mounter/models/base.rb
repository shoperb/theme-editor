module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Base < ActiveYaml::Base

        set_root_path Utils.base + "data"
        include ActiveHash::Associations

        module DefaultRelation
          def belongs_to(association_id, options = {})
            klass = klass_for(association_id, options)
            options.reverse_merge!(
              class_name: klass.to_s,
              foreign_key: "#{association_id}_#{klass.primary_key}",
              primary_key: klass.primary_key,
              optional: true
            )
            super(association_id, options)
          end
          
          def has_many(association_id, options = {})
            klass = klass_for(association_id, options)
            options.reverse_merge!(
              class_name: klass.to_s,
              foreign_key: "#{to_s.demodulize.underscore}_#{primary_key}",
            )
            super(association_id, options)
          end
          
          def has_one(association_id, options = {})
            klass = klass_for(association_id, options)
            options.reverse_merge!(
              class_name: klass.to_s,
              foreign_key: "#{to_s.demodulize.underscore}_#{primary_key}",
            )
            super(association_id, options)
          end
        end
        extend DefaultRelation
        
        class << self
          delegate :sum, :minimum, :maximum, :pluck, :ids, :includes,
            :joins, :left_joins, :references, :preload, :select, :sort_by,
            :reject, :first, :last, :page, :per, to: :all

          # make sure relation is created when necessary
          # in order to allow chaining methods
          def all
            super.to_relation(self)
          end

          def none
            [].to_relation(self)
          end

          def where(**args)
            super(**args).to_relation(self)
          end

          def not(**args)
            all.select do |item|
              args.all? do |k, v|
                if v.is_a?(Array)
                  !v.include?(item.send(k.to_s))
                else
                  item.send(k.to_s) != v
                end
              end
            end
          end

          def has_singleton_method?(name)
            singleton_methods.map { |method| method.to_sym }.include?(name)
          end

          def load_path(path)
            (File.exists?(path) ? YAML.load_file(path) : [])
          end

          def save
            (subclasses + [self] - [Base]).each do |klass|
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
              define_method arg do |*_|
                ((translations || {})[Translations.locale] || {}).fetch(arg.to_s, attributes[arg])
              end
            end
          end
        end

        def to_liquid context=nil
          if klass = (ShoperbLiquid.const_get("#{self.class.to_s.demodulize}Drop"))
            klass.new(self).tap do |drop|
              drop.context = context if context
            end
          end
        end

        def id
          self.class.primary_key.to_s == "id" ? super : send(self.class.primary_key)
        end

        def as_json(*attrs)
          attributes.as_json(*attrs)
        end
      end
    end
  end
end end end
