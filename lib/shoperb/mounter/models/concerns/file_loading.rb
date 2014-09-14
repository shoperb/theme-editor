module Shoperb
  module Mounter
    module Model
      module Concerns
        module FileLoading
          extend ActiveSupport::Concern

          module ClassMethods
            def file_extension
              "yml"
            end

            def file base="data"
              "#{base}/#{model_name.pluralize}.#{file_extension}"
            end

            def default_file
              File.expand_path("../../models/#{file("defaults")}", __dir__)
            end

            def get_objs file
              YAML::load(File.open(file).read.force_encoding("utf-8"))
            end

            def process_file objs
              result = []
              if data = objs[model_name.pluralize]
                data.each do |obj|
                  result << new(obj)
                end
              end if objs
              result
            end

            def all
              result = if File.exists?(file)
                process_file get_objs(file)
              elsif File.exists?(default_file)
                process_file get_objs(default_file)
              else
                raise Error.new("File not found: [#{file}, #{default_file}]")
              end
              Drop::Delegate::Array.new(result)
            end
          end
        end
      end
    end
  end
end

