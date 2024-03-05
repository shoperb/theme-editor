module Shoperb module Theme module Editor
  module Mounter
    module Model
      class VariantAttribute < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :value, :translations, :attribute_key
        c_fields :variant_id, cast: Integer

        translates :value

        belongs_to :variant


        def self.primary_key
          :id
        end

        dataset_module do
          def from_variant
            where(Sequel.lit("1=1"))
          end

          def from_product
            where(Sequel.lit("1=1"))
          end
        end

        def initialize(*args)
          super(*args)
          @attributes[:name] = name
        end

        def name
          attribute_key['name']
        end

        def handle
          attribute_key['handle']
        end

      end
    end
  end
end end end