module Shoperb module Theme module Liquid module Drop
  class ShippingMethod < Base
    def name
      record.name
    end

    def rate
      record.rate
    end

    def provider
      record.provider
    end

    def provider_box
      record.provider_box
    end

    def tracking_number
      record.tracking_number
    end
  end
end end end end
