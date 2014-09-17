module Shoperb
  module Mounter
    module Liquid
      class DelegateDrop < ::Liquid::Drop

        def initialize(record)
          @record = record
        end

        def inspect
          "<#{self.class.to_s} #{@record.inspect}>"
        end

        def method_missing name, *args, &block
          if name.to_s.ends_with?("?")
            !!@record.send(name.to_s[0..-2], *args, &block)
          else
            @record.send(name, *args, &block)
          end
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

      end
    end
  end
end