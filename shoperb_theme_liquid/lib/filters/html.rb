module Shoperb module Theme module Liquid module Filter
  module Html

    def modulo_word(word, index, modulo)
      index.to_i % modulo == 0 ? word : ''
    end

    def default_pagination(paginate, *args)
      return '' if paginate['parts'].empty?

      options = args_to_options(args)

      previous_label  = options[:prev] || @context.registers[:translate][@context.registers[:locale], 'pagination.previous']
      next_label      = options[:next] || @context.registers[:translate][@context.registers[:locale], 'pagination.next']
      previous_link   = link("previous", previous_label, paginate)

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

      next_link   = link("next", next_label, paginate)

      %{<div class="pagination">
        #{previous_link}
        #{links}
        #{next_link}
        </div>}
    end

    private

    def link type, label, paginate
      if paginate[type].blank?
        "<span class=\"disabled prev-page\">#{label}</span>"
      else
        "<a href=\"#{paginate[type]['url']}\" class=\"prev-page\">#{label}</a>"
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
end end end end
