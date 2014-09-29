module Shoperb
  module Mounter
    module Model
      module Concerns
        module Introspection
          extend ActiveSupport::Concern

          def inspect
            "#{self.class.model_name}(#{self.to_h})"
          end
        end
      end
    end
  end
end

