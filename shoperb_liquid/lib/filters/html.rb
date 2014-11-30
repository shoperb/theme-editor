module Shoperb
  module Liquid
    module Filter
      module Html

        def modulo_word(word, index, modulo)
          index.to_i % modulo == 0 ? word : ''
        end

        def default_pagination(paginate, *args)
          return '' if paginate['parts'].empty?

          options = args_to_options(args)

          previous_label  = options[:prev] || I18n.t('pagination.previous')
          next_label      = options[:next] || I18n.t('pagination.next')

          previous_link = (if paginate['previous'].blank?
            "<span class=\"disabled prev-page\">#{previous_label}</span>"
          else
            "<a href=\"#{paginate['previous']['url']}\" class=\"prev-page\">#{previous_label}</a>"
          end)

          links = ""
          paginate['parts'].each do |part|
            links << (if part['is_link']
              "<a class=\"page\" href=\"#{part['url']}\">#{part['title']}</a>"
            elsif part['hellip_break']
              "<span class=\"page gap\">#{part['title']}</span>"
            else
              "<span class=\"page current\">#{part['title']}</span>"
            end)
          end

          next_link = (if paginate['next'].blank?
            "<span class=\"disabled next-page\">#{next_label}</span>"
          else
            "<a href=\"#{paginate['next']['url']}\" class=\"next-page\">#{next_label}</a>"
          end)

          %{<div class="pagination">
            #{previous_link}
            #{links}
            #{next_link}
            </div>}
        end

        private

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
