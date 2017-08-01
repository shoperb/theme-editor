module Shoperb module Theme module Liquid module Drop
  class OrderItem < Base

    def name
      record.name
    end


    def quantity
      record.amount
    end


    alias :qty :quantity


    def sku
      record.sku
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


    def price
      record.price
    end


    def subtotal
      record.total_without_taxes.to_f
    end


    def total
      record.total_wout_correlation.to_f
    end


    def total_weight
      record.total_weight.to_f
    end


    def total_taxes
      record.total_taxes.to_f
    end


    def requires_shipping?
      record.require_shipping?
    end


    def requires_taxation?
      record.charge_taxes?
    end

  end
end end end end
