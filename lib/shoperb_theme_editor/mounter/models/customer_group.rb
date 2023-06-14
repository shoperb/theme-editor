module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomerGroup < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id,:name,:handle, :customer_customer_group_ids, :customer_ids

      end
    end
  end
end end end
