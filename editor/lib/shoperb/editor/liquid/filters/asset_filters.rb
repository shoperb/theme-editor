require 'action_view'
require 'action_dispatch'
module Shoperb
  module Editor
    module Liquid
      module Filters
        module Asset

          include ::ActionView::Helpers::TagHelper

          def stylesheet_tag(url, media = :screen)
            tag :link, { :rel => "stylesheet", :type => Mime::CSS, :media => media, :href => url }
          end

          def javascript_tag(url)
            content_tag :script, "", :type => Mime::JS, :src => url
          end

          def icon_tag(url)
            tags = ""
            tags << tag(:link, { :rel => "icon", :type => "image/vnd.microsoft.icon", :href => url })
            tags << "\n"
            tags << tag(:link, { :rel => "shortcut icon", :href => url })
          end

          def image_tag(url, alt = nil, title = nil)
            tag :img, { :alt => h(alt), :src => url, :title => h(title)}
          end

          def asset_url(asset)
            "/#{@context.registers["theme"].asset_url}/#{asset}"
          end

        end

        ::Liquid::Template.register_filter(Asset)
      end
    end
  end
end