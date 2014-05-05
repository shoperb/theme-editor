module Shoperb
  module Mounter
    module Models
      class SingletonBase < Base
        def self.file
          "models/#{self.model_name}.#{self.file_extension}"
        end

        def self.instance
          all.first
        end

        def self.process_file objs
          result = []
          result << new(objs) if objs
          result
        end
      end
    end
  end
end