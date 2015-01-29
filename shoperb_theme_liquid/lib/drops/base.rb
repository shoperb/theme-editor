module Shoperb module Theme module Liquid module Drop
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
      "/#{@context.registers[:locale]}" if @context.registers[:locale].present? && @context.registers[:locale] != shop.language_code
    end

    def shop
      @context.registers[:shop]
    end

    def models
      @context.registers[:models]
    end

    def model klass
      models.const_get(klass.to_s.demodulize)
    end

  end
end end end end
