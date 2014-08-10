module Shoperb
  module Mounter
    module Model
      module Concerns
        module Relations
          extend ActiveSupport::Concern

          module ClassMethods

            def has_many relation, options={}
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{options[:name] || relation}
                  DelegateArray.new(#{has_finder(relation, :select)})
                end
              RUBY
            end

            def has_one relation, options={}
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{options[:name] || relation}
                  #{has_finder(relation, :detect)}
                end
              RUBY
            end

            def has_and_belongs_to_many relation, options={}
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{options[:name] || relation}
                  DelegateArray.new(#{relation_klass(relation)}.all.select { |object| object.#{model_name}_#{finder.to_s.pluralize}.to_a.include?(self.#{finder}) })
                end
              RUBY
            end

            def belongs_to relation, options={}
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{options[:name] || relation}
                  #{polymorphic_relation_klass(relation, options)}.all.detect #{belongs_to_finder(relation)}
                end
              RUBY
            end

            private

            def polymorphic_relation_klass relation, options
              options[:polymorphic] ? "Model.const_get(self.class.send(:relation_name, #{relation}_type))" : relation_klass(relation)
            end

            def relation_klass relation
              "Model::#{relation_name(relation)}"
            end

            def relation_name relation
              relation.to_s.singularize.classify
            end

            def belongs_to_finder relation
              "{ |object| object.#{primary_key(relation)} == self.#{relation}_#{primary_key(relation)} }"
            end

            def has_finder relation, scanner
              "#{relation_klass(relation)}.all.#{scanner} { |object| object.#{model_name}_#{primary_key(relation)} == self.#{primary_key(relation)} }"
            end

            def primary_key relation
              Mounter.const_get(relation_klass(relation)).finder
            end

          end
        end
      end
    end
  end
end

