module Shoperb
  module Mounter
    module Models
      class SingletonBase < Base
        class << self
          def file base="models"
            "#{base}/#{self.model_name}.#{self.file_extension}"
          end

          def instance
            all.first
          end

          def process_file objs
            result = []
            result << new(objs) if objs
            result
          end
        end
      end
    end
  end
end