module Shoperb
  module Mounter
    module Filter
      module Translate
        extend self
        mattr_accessor :locale

        def translate(string)
          key = string.parameterize(".")
          (all_translations[locale || Model::Shop.instance.language_code] || HashWithIndifferentAccess.new).fetch(key) { key }
        end

        alias :t :translate

        def all_translations
          Dir[File.join(Utils.base, "translations", "*.json")].map do |file|
            JSON.parse(File.read(file).force_encoding('UTF-8').presence || "{}", object_class: HashWithIndifferentAccess)
          end.inject({}) do |hash, trans|
            hash.merge!(trans)
            hash
          end
        end
      end
    end
  end
end