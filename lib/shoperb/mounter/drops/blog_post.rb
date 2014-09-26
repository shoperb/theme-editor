module Shoperb
  module Mounter
    module Drop
      class BlogPost < Delegate

        def url
          "/blog_posts/#{@record.name}"
        end

      end
    end
  end
end