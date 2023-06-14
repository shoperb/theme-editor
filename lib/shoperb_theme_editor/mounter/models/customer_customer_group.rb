module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomerCustomerGroup < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id,:customer_id, :customer_group_id

      end
    end
  end
end end end
