module Shoperb
  module Mounter
    module Drop
      class Delegate < ::Liquid::Drop

        Shoperb.autoload_all self, "shoperb/mounter/drops/delegate"

        attr_reader :record

        def initialize(record)
          @record = record
        end

        def inspect
          "<#{self.class.to_s} #{@record.inspect}>"
        end

        def method_missing name, *args, &block
          @record.send(name, *args, &block)
        end

        def self.invokable?(method_name)
          # unless @invokable_methods
          #   blacklist = Liquid::Drop.public_instance_methods + [:each]
          #   if include?(Enumerable)
          #     blacklist += Enumerable.public_instance_methods
          #     blacklist -= [:sort, :count, :first, :min, :max, :include?]
          #   end
          #   whitelist = [:to_liquid] + (public_instance_methods - blacklist)
          #   @invokable_methods = Set.new(whitelist.map(&:to_s))
          # end
          # @invokable_methods.include?(method_name.to_s)
          true
        end

        private

        def __to_drop__ klass, method
          klass.new(@record.send(method)) if @record.send(method)
        end

        def __shop__
          @context && @context["shop"]
        end

      end
    end
  end
end
