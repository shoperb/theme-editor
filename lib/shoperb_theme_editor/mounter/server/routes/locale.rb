module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Routes
        module Locale

          module Helpers
            def get_locale
              if shop.possible_languages.any? && request.path_info=~(/\A\/(#{shop.possible_languages.join("|")})(\/.*)?/)
                request.path_info = $2 || ""
                $1
              elsif shop.language_code
                shop.language_code
              end
            end
          end

          def self.registered(app)
            app.helpers Helpers
            app.before "*" do
              Translations.locale = get_locale
            end

          end
        end
      end
    end
  end
end end end
