require_relative "./relations"
require_relative "./introspection"
require_relative "./file_loading"
module Shoperb
  module Mounter
    module Models
      class Base < OpenStruct

        include Relations
        include Introspection
        include FileLoading

        def to_liquid
          if klass = Object.const_get(self.class.model_name.classify + "Drop")
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

          def inherited(subclass)
            eval "::#{subclass.to_s.demodulize} = #{subclass}"
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