module Shoperb
  module Mounter
    module Liquid
      module Filter
        module Translate
          extend self
          mattr_accessor :locale

          def translate(string)
            key = string.parameterize(".")
            (all_translations[locale] || HashWithIndifferentAccess.new).fetch(key) { key }
          end

          alias :t :translate

          def all_translations
            content = File.read(File.join(Utils.base, "translations", "translations.json")).presence || "{}"
            JSON.parse(content, object_class: HashWithIndifferentAccess)
          end
        end
      end
    end
  end
end