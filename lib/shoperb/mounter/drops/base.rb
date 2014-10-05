module Shoperb
  module Mounter
    module Drop
      class Base < ::Liquid::Drop

        def initialize(record)
          @record = record
        end

        private

        def default_url
          "#{default_url_language}/#{self.class.filename}/#{self.record.to_param}"
        end

        def default_url_language
          "/#{Filter::Translate.locale}" if Filter::Translate.locale && Filter::Translate.locale != Model::Shop.instance.language_code
        end

      end
    end
  end
end