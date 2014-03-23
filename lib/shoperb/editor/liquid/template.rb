module Liquid
  class Template

    def self.parse(source)
      if source.kind_of?(Liquid::Template)
        source
      else
        template = Template.new
        template.parse(source)
        template
      end
    end

  end
end