module Shoperb module Theme module Editor
  module Translations
    extend self
    mattr_accessor :locale

    def translate(locale, string)
      key = string.parameterize(".")
      (translations[locale] || HashWithIndifferentAccess.new).fetch(key) { key }
    end

    alias :t :translate

    def translations
      Dir[File.join("translations", "*.json")].map do |file|
        JSON.parse(File.read(file).force_encoding('UTF-8').presence || "{}", object_class: HashWithIndifferentAccess)
      end.inject({}) do |hash, trans|
        hash.merge!(trans)
        hash
      end
    end
  end
end end end
