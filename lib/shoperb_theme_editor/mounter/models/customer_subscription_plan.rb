module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomerSubscriptionPlan < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :invoice_name, :description, :handle, :interval, 
          :interval_count, :item_price, :setup_cost, :trial_interval, :trial_interval_count,
          :custom_field_values

        translates :name, :invoice_name, :description

        def self.primary_key
          :id
        end
        
        def self.active
          all
        end
        
        def to_liquid context=nil
          if klass = (ShoperbLiquid.const_get("SubscriptionPlanDrop"))
            klass.new(self).tap do |drop|
              drop.context = context if context
            end
          end
        end

      end
    end
  end
end end end
