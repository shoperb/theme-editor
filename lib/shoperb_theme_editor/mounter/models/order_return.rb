# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturn < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :delivery_date, :comment, :state, :subtotal

        dataset_module do
          def by_id(dir)
            list = sort_by(&:id)
            dir == "desc" ? list.reverse : list
          end
        end
        
        def items
          OrderReturnItem.all
        end
        
        def return_parcel
          [OrderReturnParcel.first, nil].sample
        end
        
        def self.raw_data
          [
            {id: 1, delivery_date: "", comment: "", state: "pending"},
            {id: 2, delivery_date: nil, comment: nil, state: "pending"},
            {id: 3, delivery_date: Time.now+3.days, comment: "Sending back via Omniva", state: "sending"},
            {id: 4, delivery_date: Time.now+5.days, comment: "Sending back via Posti", state: "in_transit"},
            {id: 5, delivery_date: Time.now+1.days, comment: "Sending back via Posti", state: "receiving"},
            {id: 6, delivery_date: Time.now-1.days, comment: "Sending back via Omniva", state: "received"},
          ]
        end
      end
    end
  end
end end end
