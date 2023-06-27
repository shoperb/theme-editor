module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomField < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :description, :klass, :handle, :html_type
        c_fields :customer_see, :customer_edit, :customer_delete, cast: TrueClass
        c_fields :html_values, :default_values, cast: JSON

        def self.primary_key
          "id"
        end

        class ::ShoperbLiquid::Base::CustomField < Shoperb::Theme::Editor::Mounter::Model::CustomField
        end

      end
    end
  end
end end end
