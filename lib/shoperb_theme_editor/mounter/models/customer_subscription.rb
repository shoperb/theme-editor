# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomerSubscription < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :plan_id, :customer_id, :auto_collection, :state, :qty,
          :custom_field_values, :starts_at, :ends_at, :trial_starts_at, :trial_ends_at,
          :gift_card_code

        def self.primary_key
          :id
        end

        belongs_to :plan, class_name: CustomerSubscriptionPlan.to_s, foreign_key: :plan_id
        belongs_to :customer


        def active?
          state == "active"
        end

        def self.active
          all
        end

        def to_liquid context=nil
          if klass = (ShoperbLiquid.const_get("SubscriptionDrop"))
            klass.new(self).tap do |drop|
              drop.context = context if context
            end
          end
        end

      end
    end
  end
end end end
