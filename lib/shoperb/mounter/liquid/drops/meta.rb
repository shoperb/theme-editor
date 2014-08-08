module Shoperb
  module Mounter
    module Liquid
      module Drop
        class Meta < Liquid::DelegateDrop
          def method_missing name, *args, &block
            @record.send(name, *args, &block) if @record
          end
        end
      end
    end
  end
end