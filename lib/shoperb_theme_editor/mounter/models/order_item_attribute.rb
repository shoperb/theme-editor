module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderItemAttribute < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        # todo: TODOREF2
        def self.from_variant
          all
        end
        def self.from_product
          all
        end
      end
    end
  end
end end end
