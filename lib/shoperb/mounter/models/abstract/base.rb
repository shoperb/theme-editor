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

          class << self
            attr_accessor :finder

            def finder= attribute
              @finder = attribute
            end

            def find id
              all.detect { |o| o.send(finder || :id).to_s == id.to_s }
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