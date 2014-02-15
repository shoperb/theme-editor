module Shoperb
  module Mounter
    module Models

      module Relations
        extend ActiveSupport::Concern
        module ClassMethods
          def has_many relation
            class_eval <<-STRING
              def #{relation}
                if mounting_point.respond_to?(:#{relation})
                  mounting_point.#{relation}.select { |v| v.#{to_s.downcase.underscore}_id == id }
                elsif mounting_point.respond_to?(:#{relation.to_s.singularize})
                  mounting_point.#{relation.to_s.singularize}
                end
              end
            STRING
          end
          def has_one relation
            class_eval <<-STRING
              def #{relation}
                if mounting_point.respond_to?(:#{relation.to_s.pluralize})
                  mounting_point.#{relation.to_s.pluralize}.detect { |v| v.#{to_s.downcase.underscore}_id == id || v.#{to_s.downcase.underscore}_id.nil? }
                elsif mounting_point.respond_to?(:#{relation})
                  mounting_point.#{relation}
                end
              end
            STRING
          end

          def belongs_to relation
            class_eval <<-STRING
              def #{relation}
                if mounting_point.respond_to?(:#{relation.to_s.pluralize})
                  mounting_point.#{relation.to_s.pluralize}.detect { |v| #{to_s.downcase.underscore}_id == v.id || v.id.nil? }
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
            mounting_point.send(self.to_s.pluralize)
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
      end

    end
  end
end