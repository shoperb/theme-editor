module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Base < ::Liquid::Drop

        attr_reader :record

        def initialize(record)
          @record = record
        end

        def inspect
          "#{self.class.to_s}(#{record.id})"
        end

        private

        def default_url id=self.record.id
          "#{default_url_language}/#{self.record.class.filename}/#{id}"
        end

        def default_url_language
          "/#{Translations.locale}" if Translations.locale && Translations.locale != Model::Shop.first.language_code
        end

        def shop
          Model::Shop.first
        end

      end
    end
  end
end end end
