module Shoperb module Theme module Liquid module Drop
  class Customer < Base

    def name
      record.name
    end

    def first_name
      record.first_name
    end

    def last_name
      record.last_name
    end

    def email
      record.email
    end

    def accepts_newsletter?
      record.newsletter
    end

    def registred?
      record.active?
    end

    def last_billing_address
      record.last_bill_address.try(:to_liquid, @context)
    end

    def last_shipping_address
      record.last_ship_address.try(:to_liquid, @context)
    end

    def addresses
      Collection.new(record.addresses).tap do |drop|
        drop.context = @context
      end
    end

    def discount_pct
      record.discount_pct
    end

    def orders
      Collection.new(record.orders).tap do |drop|
        drop.context = @context
      end
    end

    def logged_in?
      record.try(:id).present?
    end

    def recommended_products
      Products.new(record.recommended_products).tap do |drop|
        drop.context = @context
      end
    end

    def company?
      record.company?
    end

    def personal?
      !record.company?
    end

    def company_name
      record.company_name
    end

    def vat_number
      record.vat_number
    end

  end
end end end end
