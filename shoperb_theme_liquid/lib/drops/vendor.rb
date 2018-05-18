module Shoperb module Theme module Liquid module Drop
  class Vendor < Base

    def initialize(record)
      @record = record || model(self.class).new({})
    end

    def id
      record.id
    end

    def handle
      record.handle
    end

    def name
      record.name
    end

    def description
      record.description
    end

    def code
      record.code
    end

    def fax
      record.fax
    end

    def phone
      record.phone
    end

    def email
      record.email
    end

    def website
      record.website
    end

    def contact_name
      record.contact_name
    end

    def contact_phone
      record.contact_phone
    end

    def contact_email
      record.contact_email
    end

    def image
      Image.new(record.image) if record.image
    end

    def address
      Address.new(record.address) if record.address
    end

    def products
      Products.new(record.products)
    end

    def url
      default_url
    end

  end
end end end end
