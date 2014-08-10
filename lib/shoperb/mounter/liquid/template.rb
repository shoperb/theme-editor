module Shoperb
  module Mounter
    module Liquid
      class Template < ::Liquid::Template

        def self.parse(source)
          if source.kind_of?(::Liquid::Template)
            source
          else
            template = ::Liquid::Template.new
            template.parse(source)
            template
          end
        end

      end
    end
  end
end