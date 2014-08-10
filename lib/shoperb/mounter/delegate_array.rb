module Shoperb
  module Mounter
    class DelegateArray < Array

      attr_writer :context

      def method_missing(name, *args, &block)
        class_eval do
          define_method name do |*args, &block|
            DelegateArray.new(self)
          end
        end
        send(name, *args, &block)
      end

      def has_key? name
        true
      end

      def [] key
        case key
          when Integer
            super(key)
          else
            send(key)
        end
      end

      def inspect
        "DA#{super}"
      end

    end
  end
end