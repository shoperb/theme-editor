module Shoperb
  module Mounter
    module Drop
      class Variant < Delegate

        def options
          record.variant_attributes.map(&:value)
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

        def discount_price
          record.price_discount
        end

        def discount?
          record.discount_active?
        end

        def discount_period?
          record.has_discount_range?
        end

        def discount_start
          record.formatted_discount_start
        end

        def discount_end
          record.formatted_discount_end
        end

        def current_price
          record.active_price
        end

        def stock
          record.track_inventory? ? record.stock : nil
        end

        def json
          @record.to_h.merge(attributes: @record.variant_attributes.map(&:to_h)).to_json
        end

      end
    end
  end
end