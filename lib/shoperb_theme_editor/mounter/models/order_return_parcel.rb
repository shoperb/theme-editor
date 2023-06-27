# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturnParcel < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :provider, :barcode, :state, :filename, :url
        
        
        def self.raw_data
          [
            {id: 1, provider: "royalmail_uk", barcode: "qqqqaaaa", state: "uploaded", filename: '628x800.png', url: "https://via.placeholder.com/628x800.png?text=Here+will+be+shipping+label"},
            {id: 2, provider: "custom", barcode: nil, state: "local", filename: nil, url: "/system/stock/return_parcels/20190606/2/"},
          ]
        end
      end
    end
  end
end end end
