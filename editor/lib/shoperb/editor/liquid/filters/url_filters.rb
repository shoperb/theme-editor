require 'action_view'
module Shoperb
  module Editor
    module Liquid
      module Filters
        module Url

          include ::ActionView::Helpers::UrlHelper

          def link_to_category(category)
            link_to category.name, category.url, category.name
          end

          def link_to_product(product)
            link_to product.name, product.url, product.name
          end

          def link_to_page(page)
            link_to page.name, page.url, page.name
          end

          def link_to_collection(collection)
            link_to collection.name, collection.url, collection.name
          end

          def link_to_locale(text, locale)
            url = @context.registers[:controller].url_for(locale: locale)

            link_to text, url
          end

          def link_to_root(text)
            link_to text, "/"
          end

          def link_to(text, url, title = nil)
            super text, url, :title => title
          end
        end

        ::Liquid::Template.register_filter(Url)

      end
    end
  end
end