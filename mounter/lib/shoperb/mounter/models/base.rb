module Shoperb
  module Mounter
    module Models

      module Relations
        extend ActiveSupport::Concern
        module ClassMethods
          def has_many relation, options={}
            class_eval <<-STRING
              def #{options[:name] || relation}
                if mounting_point.respond_to?(:#{relation})
                  mounting_point.#{relation}.select { |v| v.#{to_s.demodulize.underscore}_id == id }
                elsif mounting_point.respond_to?(:#{relation.to_s.singularize})
                  mounting_point.#{relation.to_s.singularize}
                end
              end
            STRING
          end
          def has_one relation, options={}
            class_eval <<-STRING
              def #{options[:name] || relation}
                if mounting_point.respond_to?(:#{relation.to_s.pluralize})
                  mounting_point.#{relation.to_s.pluralize}.detect { |v| v.#{to_s.demodulize.underscore}_id == id || v.#{to_s.downcase.underscore}_id.nil? }
                elsif mounting_point.respond_to?(:#{relation})
                  mounting_point.#{relation}
                end
              end
            STRING
          end

          def belongs_to relation, options={}
            class_eval <<-STRING
              def #{options[:name] || relation}
                if mounting_point.respond_to?(:#{relation.to_s.pluralize})
                  mounting_point.#{relation.to_s.pluralize}.detect { |v| #{relation.to_s.singularize}_id == v.id }
                elsif mounting_point.respond_to?(:#{relation.to_s.singularize})
                  mounting_point.#{relation.to_s.singularize}
                end
              end
            STRING
          end
        end
      end

      module All
        extend ActiveSupport::Concern
        module ClassMethods
          def all
            mounting_point.send(self.to_s.demodulize.pluralize.underscore)
          end
        end
      end
      class Base < OpenStruct
        include Relations
        include All

        def self.inherited(subclass)
          subclass.class_eval do
            def self.mounting_point
              @@mounting_point
            end

            def self.mounting_point= value
              @@mounting_point = value
            end
          end
          eval "::#{subclass.to_s.demodulize} = #{subclass}"
        end

        def to_liquid
          if klass = Object.const_get(self.class.name + "Drop")
            klass.new(self)
          end
        end
      end

    end
  end
end