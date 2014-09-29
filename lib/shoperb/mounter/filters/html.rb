module Shoperb
  module Mounter
    module Filter
      module Html

        def modulo_word(word, index, modulo)
          index.to_i % modulo == 0 ? word : ""
        end

        def default_pagination(paginate, *args)
          return "" if paginate["parts"].empty?

          options = args_to_options(args)

          %{<div class="pagination">
          #{pagination_link(paginate, "previous", options[:prev] || Translate.t("pagination.previous"))}
          #{pagination_page_links(paginate)}
          #{pagination_link(paginate, "next", options[:next] || Translate.t("pagination.next"))}
            </div>}
        end

        private

        def pagination_page_links paginate
          links = ""
          paginate["parts"].each do |part|
            links << (
            if part["is_link"]
              "<a class=\"page\" href=\"#{part["url"]}\">#{part["title"]}</a>"
            elsif part["hellip_break"]
              "<span class=\"page gap\">#{part["title"]}</span>"
            else
              "<span class=\"page current\">#{part["title"]}</span>"
            end)
          end
          links
        end

        def pagination_link paginate, type, label
          if paginate[type].blank?
            "<span class=\"disabled next-page\">#{label}</span>"
          else
            "<a href=\"#{paginate[type]["url"]}\" class=\"next-page\">#{label}</a>"
          end
        end

        def args_to_options(*args)
          options = {}
          args.flatten.each do |a|
            if (a =~ /^(.*):(.*)$/)
              options[$1.to_sym] = $2
            end
          end
          options
        end

      end
    end
  end
end