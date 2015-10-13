module Shoperb module Theme module Liquid module Drop
  class Order < Base

    def name
      "#" + record.number
    end

    def number
      record.number
    end

    def token
      record.token
    end

    def email
      record.email
    end

    def total
      record.total
    end

    def subtotal
      record.subtotal
    end

    def total_shipping
      record.total_shipping
    end

    def total_taxes
      record.total_taxes
    end

    def requires_shipping?
      record.require_shipping?
    end

    def requires_taxation?
      record.require_taxation?
    end

    def created_at
      record.created_at
    end

    def state
      record.state
    end

    def notes
      record.notes
    end

    def shipping_method
      record.shipping_method.try(:to_liquid, @context)
    end

    def payment_method
      record.payment_method.try(:to_liquid, @context)
    end

    def payment_method_name
      record.payment_method.name
    end

    def billing_address
      record.bill_address.try(:to_liquid, @context)
    end

    def shipping_address?
      !!record.ship_address
    end

    def shipping_address
      record.ship_address.try(:to_liquid, @context)
    end

    def items
      Collection.new(record.items).tap do |drop|
        drop.context = @context
      end
    end

    def customer
      record.customer.try(:to_liquid, @context)
    end

    def currency
      record.currency.try(:to_liquid, @context)
    end


    def url
      default_url number
    end

  end
end end end end
