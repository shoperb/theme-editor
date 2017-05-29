module Shoperb module Theme module Liquid module Filter
  module Asset
    #include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper

    def stylesheet_tag(url, media = :screen)
      check_asset_defined_in_spec(url, :stylesheets)
      tag :link, { :rel => "stylesheet", :type => Mime::CSS, :media => media, :href => url }
    end

    def javascript_tag(url)
      check_asset_defined_in_spec(url, :javascripts)
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

    def style_tag(data, id = nil)
      content_tag :style, data, type: 'text/css', id: id
    end

    def asset_url(asset)
      asset = asset.gsub(/^\//, '')
      @context.registers[:asset_url][asset]
    end

    private

    def check_asset_defined_in_spec(url, type)
      relative_url = url.gsub(/\/system\/assets\/#{type}\//, '')
      unless send("compiled_#{type}").include?(relative_url)
        raise Editor::Error.new("#{type.to_s.singularize.titleize} #{relative_url} is not defined in SPEC, but served")
      end
    end

    def compiled_assets
      @compiled_assets ||= JSON.parse(Shoperb::Theme::Editor.local_spec_content)['compile']
    end

    def compiled_stylesheets
      compiled_assets['stylesheets']
    end

    def compiled_javascripts
      compiled_assets['javascripts']
    end
  end
end end end end
