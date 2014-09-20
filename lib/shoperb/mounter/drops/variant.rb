module Shoperb
  module Mounter
    module Drop
      class Variant < Delegate

        def options
          @record.variant_attributes.map(&:value)
        end

        def image
          __to_drop__ Drop::Image, :image
        end

        def images
          __to_drop__ Drop::Collection, :images
        end

        def attributes
          __to_drop__ Drop::Collection, :variant_attributes
        end

        def json
          @record.to_h.merge(attributes: @record.variant_attributes.map(&:to_h)).to_json
        end

      end
    end
  end
end