module Shoperb
  module Editor
    module Models
      class Translation < SingletonBase
        belongs_to :theme

        def parsed
          return @parsed if defined?(@parsed)

          if data.present?
            @parsed = ActiveSupport::JSON.decode(data) rescue {}
          else
            @parsed = {}
          end
        end

        def translate(locale, string)
          if locale = parsed[locale.to_s]
            locale[string.to_s]
          end
        end
      end
    end
  end
end

