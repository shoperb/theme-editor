module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Order < Base

        fields :id, :number, :token, :email, :total, :subtotal, :total_shipping, :total_taxes, :require_shipping, :require_taxation, :created_at, :state, :notes

        has_one :shipping_method

        belongs_to :ship_address

        belongs_to :bill_address

        belongs_to :customer
      end
    end
  end
end end end
