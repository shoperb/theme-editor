module Shoperb
  module Mounter
    module Drop
      class Meta < Delegate

        def title
          @record.try(:meta_title) || __shop__.meta_title
        end

        def description
          @record.try(:meta_description) || __shop__.meta_description
        end

        def keywords
          @record.try(:meta_keywords) || __shop__.meta_keywords
        end

      end
    end
  end
end