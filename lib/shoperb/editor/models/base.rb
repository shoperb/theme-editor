module Shoperb
  module Editor
    module Models
      class Base < OpenStruct

        def to_liquid
          if klass = Object.const_get(self.class.model_name.classify + "Drop")
            klass.new(self)
          end
        end

        def inspect
          "#{self.class.model_name}(#{self.id})"
        end

        def self.method_missing(name, *args, &block)
          self.all
        end

        def self.all
          result = []
          if File.exists?(file)
            objs   = YAML::load(File.open(file).read.force_encoding('utf-8'))
            result = process_file objs
          end
          DelegateArray.new(result)
        end

        def self.process_file objs
          result = []
          if data = objs[model_name.pluralize]
            data.each do |obj|
              result << new(obj)
            end
          end if objs
          result
        end

        def self.model_name
          self.name.split('::').last.underscore
        end

        def self.file
          "models/#{self.model_name.pluralize}.#{self.file_extension}"
        end

        def self.file_extension
          "yml"
        end

        def self.find id
          self.all.detect { |o| o.id.to_s == id.to_s }
        end

        def self.inherited(subclass)
          eval "::#{subclass.to_s.demodulize} = #{subclass}"
        end

        class << self
          def has_many relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                klass = #{relation.to_s.singularize.classify.inspect}.constantize
                DelegateArray.new(klass.all.select { |object| object.#{model_name}_id == self.id })
              end
            STRING
          end

          def has_one relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                klass = #{relation.to_s.classify.inspect}.constantize
                klass.all.detect { |object| object.#{model_name}_id == self.id }
              end
            STRING
          end

          def belongs_to relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                if relation_id = self.#{relation}_id
                  klass = #{relation.to_s.classify.inspect}.constantize
                  klass.all.detect { |object| object.id == relation_id }
                end
              end
            STRING
          end
        end

      end
    end
  end
end