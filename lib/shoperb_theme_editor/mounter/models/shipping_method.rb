module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ShippingMethod < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        c_fields :order_id, cast: Integer
        c_fields :rate, cast: BigDecimal
        c_fields :name,:provider,:provider_box,:tracking_number, cast: String

        belongs_to :order

        def self.raw_data
          [
            {
             id: 1,
             order_id: 1,
             name: "Delivery by courier",
             rate: 0.0,
             provider: nil,
             provider_box: nil,
             tracking_number: nil,
           },
           {
            id: 2,
            order_id: 1,
            name: "Omniva",
            rate: 0.2e1,
            provider: "post24",
            provider_box: "Haapsalu Uuemõisa Konsumi pakiautomaat",
            tracking_number: "23131414212312",
          },
          ]
        end
      end
    end
  end
end end end
