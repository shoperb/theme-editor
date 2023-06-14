module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Review < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id,
               :product_id,
               :customer_id,
               :state,
               :title,
               :body,
               :rating,
               :created_at,
               :updated_at

        def self.primary_key
          :id
        end

        belongs_to :customer
        belongs_to :product

        def self.visible
          all.select { |r| ['new', 'accepted'].include?(r.state) }
        end

        def self.with_content
          all.select { |r| r.title.present? || r.body.present? }
        end

      end
    end
  end
end end end
