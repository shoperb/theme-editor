module Shoperb
  module Mounter
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

        class << self
          attr_accessor :finder

          def has_many relation, options={}
            options[:attribute] ||= :id
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                klass = #{relation.to_s.singularize.classify.inspect}.constantize
                DelegateArray.new(klass.all.select { |object| object.#{model_name}_#{options[:attribute]} == self.#{options[:attribute]} })
              end
            STRING
          end

          def has_one relation, options={}
            options[:attribute] ||= :id
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                klass = #{relation.to_s.classify.inspect}.constantize
                klass.all.detect { |object| object.#{model_name}_#{options[:attribute]} == self.#{options[:attribute]} }
              end
            STRING
          end

          def belongs_to relation, options={}
            options[:attribute] ||= :id
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                if relation_id = self.#{relation}_#{options[:attribute]}
                  klass = #{relation.to_s.classify.inspect}.constantize
                  klass.all.detect { |object| object.#{options[:attribute]} == relation_id }
                end
              end
            STRING
          end

          def finder= attribute
            @finder = attribute
          end

          def find id
            all.detect { |o| o.send(finder || :id).to_s == id.to_s }
          end

          def inherited(subclass)
            eval "::#{subclass.to_s.demodulize} = #{subclass}"
          end

          def file_extension
            "yml"
          end

          def model_name
            name.split('::').last.underscore
          end

          def file base="data"
            "#{base}/#{model_name.pluralize}.#{file_extension}"
          end

          def default_file
            File.expand_path("../#{file("default_models")}", __dir__)
          end

          def method_missing(name, *args, &block)
            all
          end

          def all
            result = []
            if File.exists?(file)
              objs   = YAML::load(File.open(file).read.force_encoding('utf-8'))
              result = process_file objs
            elsif File.exists?(default_file)
              objs   = YAML::load(File.open(default_file).read.force_encoding('utf-8'))
              result = process_file objs
            else
              raise "File not found: [#{file}, #{default_file}]"
            end
            DelegateArray.new(result)
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
        end

      end
    end
  end
end