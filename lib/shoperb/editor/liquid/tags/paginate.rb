module Liquid
  # Paginate a collection
  #
  # Usage:
  #
  # {% paginate contents.projects by 5 %}
  #   {% for project in paginate.collection %}
  #     {{ project.name }}
  #   {% endfor %}
  #  {% endpaginate %}
  #

  class Paginate < ::Liquid::Block

    Syntax = /(#{::Liquid::Expression}+)\s+by\s+([0-9]+)/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @collection_name = $1
        @per_page        = $2.to_i
      else
        raise ::Liquid::SyntaxError.new("Syntax Error in 'paginate' - Valid syntax: paginate <collection> by <number>")
      end

      super
    end

    def render(context)
      context.stack do
        collection = context[@collection_name]

        raise ::Liquid::ArgumentError.new("Cannot paginate array '#{@collection_name}'. Not found.") if collection.nil?

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

        path = context['path']

        has_prev_page        = (paginator[:page] - 1) >= 1
        has_next_page        = (paginator[:page] + 1) <= scope.collection.num_pages

        paginator[:previous] = link(::I18n.t('pagination.previous'), paginator[:page] - 1, path) if has_prev_page
        paginator[:next]     = link(::I18n.t('pagination.next'), paginator[:page] + 1, path) if has_next_page

        hellip_break = false

        if paginator[:pages] > 1
          1.upto(paginator[:pages]) do |page|

            if paginator[:page] == page
              paginator[:parts] << no_link(page)
            elsif page == 1
              paginator[:parts] << link(page, page, path)
            elsif page == paginator[:pages]
              paginator[:parts] << link(page, page, path)
            elsif page <= paginator[:page] - window_size || page >= paginator[:page] + window_size
              next if hellip_break
              paginator[:parts] << no_link('&hellip;')
              hellip_break = true
              next
            else
              paginator[:parts] << link(page, page, path)
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
      3
    end

    def no_link(title)
      {'title' => title, 'is_link' => false, 'hellip_break' => title == '&hellip;'}
    end

    def link(title, page, path)
      {'title' => title, 'url' => path + "?page=#{page}", 'is_link' => true}
    end

  end
end