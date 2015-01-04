module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Variant < Base

        def id
          record.id
        end

        def name
          record.name
        end

        def price
          record.price
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

        def available?
          record.available?
        end

        def sku
          record.sku
        end

        def stock
          record.track_inventory? ? record.stock : nil
        end

        def weight
          record.weight
        end

        def width
          record.width
        end

        def height
          record.height
        end

        def depth
          record.depth
        end

        def options
          record.variant_attributes.map(&:value)
        end

        def image
          Image.new(record.image) if record.image
        end

        def images
          Collection.new(record.images.sorted)
        end

        def attributes
          Collection.new(record.variant_attributes)
        end

        def json
          record.attributes.merge(attributes: record.variant_attributes.map(&:attributes)).to_json
        end

      end
    end
  end
end end end
