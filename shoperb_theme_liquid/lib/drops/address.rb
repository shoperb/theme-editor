module Shoperb module Theme module Liquid module Drop
  class Address < Base

    def name # not in use now
      record.name
    end

    def first_name
      record.first_name
    end

    def last_name
      record.last_name
    end

    def full_name
      record.full_name
    end

    def company
      record.company
    end

    def email
      record.email
    end

    def phone
      record.phone
    end

    def full_address
      record.full_address
    end

    def company_with_phone
      record.company_with_phone
    end

    def city_state_with_zip
      record.city_state_with_zip
    end

    def street
      record.full_address
    end

    def address1
      record.address1
    end

    def address2
      record.address2
    end

    def city
      record.city
    end

    def state
      record.state_name
    end

    def country
      record.country_name
    end

    def url
      if record.owner_type == "Customer"
        default_url id
      else
        default_index_url
      end
    end
  end
end end end end
