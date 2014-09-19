module Shoperb
  module Mounter
    module Model
      module Abstract
        class Base < OpenStruct

          include Model::Concerns::Relations
          include Model::Concerns::Introspection
          include Model::Concerns::FileLoading

          def to_liquid
            if klass = Mounter.const_get("Liquid::Drop::#{self.class.model_name.camelize}")
              klass.new(self)
            end
          end

          def self.inherited base
            base.cattr_accessor :finder
            base.finder = :name
          end

          def has_key? name
            true
          end

          def method_missing name, *args, &block
            if name.to_s.ends_with?("?")
              !!self[name.to_s[0..-2]]
            else
              self[name]
            end
          end

          def url
            "/#{self.class.model_name.pluralize}/#{super.presence || name}"
          end

          def id
            self.send self.class.finder
          end

          class << self

            def invokable?(method_name)
              true
            end

            def find id
              all.detect { |o| o.id.to_s == id.to_s }
            end

            def model_name
              name.split("::").last.underscore
            end

            def method_missing(name, *args, &block)
              class_eval do
                define_method name do |*args, &block|
                  all
                end
              end
              send(name, *args, &block)
            end
          end
        end
      end
    end
  end
end