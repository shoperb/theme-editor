module Shoperb
  module Mounter
    module Models
      module Introspection
        extend ActiveSupport::Concern

        def inspect
          "#{self.class.model_name}(#{self.id})"
        end
      end
    end
  end
end

