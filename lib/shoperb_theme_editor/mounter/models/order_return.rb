# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturn < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :delivery_date, :comment, :state, :subtotal, :created_at

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
            {id: 1, delivery_date: "", comment: "", state: "pending", created_at: Time.now},
            {id: 2, delivery_date: nil, comment: nil, state: "pending", created_at: Time.now - 3600},
            {id: 3, delivery_date: Time.now+3.days, comment: "Sending back via Omniva", state: "sending", created_at: Time.now},
            {id: 4, delivery_date: Time.now+5.days, comment: "Sending back via Posti", state: "in_transit", created_at: Time.now},
            {id: 5, delivery_date: Time.now+1.days, comment: "Sending back via Posti", state: "receiving", created_at: Time.now},
            {id: 6, delivery_date: Time.now-1.days, comment: "Sending back via Omniva", state: "received", created_at: Time.now},
          ]
        end
      end
    end
  end
end end end
