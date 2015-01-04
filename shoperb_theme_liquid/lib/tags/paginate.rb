module Shoperb module Theme module Liquid module Tag
  class Paginate < ::Liquid::Block
    Syntax = /(#{::Liquid::QuotedFragment})\s*(by\s*(\d+))?/ # failing on paginate products.order_by_name_asc by 9
    # Syntax = /(#{::Liquid::Expression}+)\s+by\s+(\d+)/


    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @collection_name = $1
        @per_page       = $2 ? $3.to_i : 20

        @attributes = { 'window_size' => 3 }
        markup.scan(::Liquid::TagAttributes){|key, value| @attributes[key] = value }
      else
        raise ::Liquid::SyntaxError.new("Syntax Error in 'paginate' - Valid syntax: paginate <collection> by <number>")
      end

      super
    end

    def render(context)
      context.stack do
        collection = context[@collection_name]
        current   = context["current_page"] == 0 ? 1 : context["current_page"]
        scope     = collection.send(:paginate, current, @per_page)
        paginator = {
          :pages      => scope.collection.num_pages,
          :total      => scope.collection.total_count,
          :last       => scope.collection.total_count - 1,
          :size       => scope.collection.limit_value,
          :offset     => scope.collection.respond_to?(:offset_value) ? scope.collection.offset_value : scope.collection.offset,
          :first      => 1,
          :page       => current,
          :previous   => nil,
          :next       => nil,
          :parts      => [],
          :collection => scope
        }

        path         = context['path']
        other_params = context['get_params']

        has_prev_page = (paginator[:page] - 1) >= 1
        has_next_page = (paginator[:page] + 1) <= scope.collection.num_pages

        paginator[:previous]  = link(context.registers[:translate][context.registers[:locale], 'pagination.previous'], paginator[:page] - 1, path, other_params) if has_prev_page
        paginator[:next]      = link(context.registers[:translate][context.registers[:locale], 'pagination.next'],     paginator[:page] + 1, path, other_params) if has_next_page

        hellip_break = false

        if paginator[:pages] > 1
          1.upto(paginator[:pages]) do |page|

            if paginator[:page] == page
              paginator[:parts] << no_link(page)
            elsif page == 1
              paginator[:parts] << link(page, page, path, other_params)
            elsif page == paginator[:pages]
              paginator[:parts] << link(page, page, path, other_params)
            elsif page <= paginator[:page] - window_size || page >= paginator[:page] + window_size
              next if hellip_break
              paginator[:parts] << no_link('&hellip;')
              hellip_break = true
              next
            else
              paginator[:parts] << link(page, page, path, other_params)
            end

            hellip_break = false

          end
        end

        context['paginate'] = paginator.stringify_keys!

        render_all(@nodelist, context)
      end
    end

    private

    def window_size
      @attributes['window_size']
    end

    def no_link(title)
      { 'title' => title, 'is_link' => false, 'hellip_break' => title == '&hellip;' }
    end

    def link(title, page, path, other_params = {})
      params = other_params.merge("page" => page)
      { 'title' => title, 'url' => path + "?#{params.to_query}", 'is_link' => true}
    end

  end
end end end end
