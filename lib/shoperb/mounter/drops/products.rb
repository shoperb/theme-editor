module Shoperb
  module Mounter
    module Drop
      class Products < Collection

        def before_method(method, *args)
          if method.match(/order_by_(.*)_(asc|desc)/i)
            collection and self
          else
            super(method)
          end
        end

        def handle_method
          :permalink
        end

      end
    end
  end
end