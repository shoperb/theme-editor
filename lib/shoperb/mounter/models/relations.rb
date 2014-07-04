module Shoperb
  module Mounter
    module Models
      module Relations
        extend ActiveSupport::Concern

        module ClassMethods
          def relation_klass relation
            relation.to_s.singularize.classify
          end

          def has_many relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                DelegateArray.new("#{relation_klass(relation)}".constantize.all.select { |object| object.#{model_name}_#{primary_key(options)} == self.#{primary_key(options)} })
              end
            STRING
          end

          def has_one relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                "#{relation_klass(relation)}".constantize.all.detect { |object| object.#{model_name}_#{primary_key(options)} == self.#{primary_key(options)} }
              end
            STRING
          end

          def belongs_to relation, options={}
            class_eval <<-STRING, __FILE__, __LINE__ + 1
              def #{options[:name] || relation}
                if relation_id = self.#{relation}_#{primary_key(options)}
                  "#{relation_klass(relation)}".constantize.all.detect { |object| object.#{primary_key(options)} == relation_id }
                end
              end
            STRING
          end

          def primary_key options={}
            options[:attribute] ||= :id
          end
        end
      end
    end
  end
end

