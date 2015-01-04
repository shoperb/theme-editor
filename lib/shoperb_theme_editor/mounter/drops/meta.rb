module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Meta < Base

        def initialize(record)
          @record = record if record.respond_to?(:has_meta_attributes?)
        end

        def title
          record.try(:meta_title).blank? ? shop.try(:meta_title) : record.meta_title
        end

        def description
          record.try(:meta_description).blank? ? shop.try(:meta_description) : record.meta_description
        end

        def keywords
          record.try(:meta_keywords).blank? ? shop.try(:meta_keywords) : record.meta_keywords
        end

      end
    end
  end
end end end
