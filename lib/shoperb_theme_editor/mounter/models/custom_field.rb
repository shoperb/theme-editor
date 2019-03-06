module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CustomField < Base

        fields :id, :name, :description, :klass, :handle,
          :customer_see, :customer_edit, :customer_delete,
          :html_type, :html_values, :default_values

        def self.primary_key
          "id"
        end

      end
    end
  end
end end end
