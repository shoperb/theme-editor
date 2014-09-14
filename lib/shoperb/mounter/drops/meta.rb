module Shoperb
  module Mounter
    module Drop
      class Meta < Delegate
        def method_missing name, *args, &block
          @record.send(name, *args, &block) if @record
        end
      end
    end
  end
end