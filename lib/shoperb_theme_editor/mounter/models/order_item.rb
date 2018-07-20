module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderItem < Base
        fields :id, :name, :amount, :sku, :weight, :width, :depth,
          :price, :total_without_taxes, :total_wout_correlation,
          :total_weight, :total_taxes, :require_shipping, :charge_taxes

        belongs_to :order
      end
    end
  end
end end end
