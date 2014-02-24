module Shoperb
  module Mounter
    module Models
      class Fragment < Base
        def parse
          Liquid::Template.parse(Pathname.new(filepath).read)
        end
      end
    end
  end
end

