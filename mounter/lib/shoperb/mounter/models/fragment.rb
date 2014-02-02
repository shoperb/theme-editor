module Shoperb
  module Mounter
    module Models
      class Fragment < Base
        def render context
          template = Liquid::Template.new
          template.parse File.read(filepath)
          template.render(context)
        end
      end
    end
  end
end

