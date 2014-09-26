module Shoperb
  module Mounter
    module Tag
      class Paginate < ::Liquid::Block
        StrictQuotedFragment = /"[^"]+"|'[^']+'|[^\s|:,]+/
        FirstFilterArgument  = /#{::Liquid::FilterArgumentSeparator}(?:#{StrictQuotedFragment})/o
        OtherFilterArgument  = /#{::Liquid::ArgumentSeparator}(?:#{StrictQuotedFragment})/o
        SpacelessFilter      = /^(?:'[^']+'|"[^"]+"|[^'"])*#{::Liquid::FilterSeparator}(?:#{StrictQuotedFragment})(?:#{FirstFilterArgument}(?:#{OtherFilterArgument})*)?/o
        Expression           = /(?:#{::Liquid::QuotedFragment}(?:#{SpacelessFilter})*)/o

        Syntax = /(#{Expression}+)\s+by\s+([0-9]+)/

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

            raise ::Liquid::SyntaxError.new("Cannot paginate array '#{@collection_name}'. Not found.") if collection.nil?

            current   = context["params.page"].to_i
            scope     = collection.send(:paginate, current, @per_page)

            paginator = base(scope, current, context)

            path = context["path"]

            add_prev_next paginator, scope, path

            hellip_break = false

            add_pages paginator, path, hellip_break

            context["paginate"] = paginator.stringify_keys!

            render_all(@nodelist, context)
          end
        end

        private

        def base scope, current, context
          {
            :total      => context["params.pagination.total"].to_i,
            :size       => context["params.pagination.size"].to_i,
            :pages      => context["params.pagination.pages"].to_i,
            :last       => context["params.pagination.last"].to_i,
            :offset     => context["params.pagination.offset"].to_i,
            :first      => 1,
            :page       => current,
            :previous   => nil,
            :next       => nil,
            :parts      => [],
            :collection => scope
          }
        end

        def add_pages paginator, path, hellip_break
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
                paginator[:parts] << no_link("&hellip;")
                hellip_break = true
                next
              else
                paginator[:parts] << link(page, page, path)
              end

              hellip_break = false

            end
          end
        end

        def add_prev_next paginator, scope, path
          has_prev_page        = (paginator[:page] - 1) >= 1
          has_next_page        = (paginator[:page] + 1) <= paginator[:pages]

          paginator[:previous] = link(::I18n.t("pagination.previous"), paginator[:page] - 1, path) if has_prev_page
          paginator[:next]     = link(::I18n.t("pagination.next"), paginator[:page] + 1, path) if has_next_page
        end

        def window_size
          3
        end

        def no_link(title)
          {"title" => title, "is_link" => false, "hellip_break" => title == "&hellip;"}
        end

        def link(title, page, path)
          {"title" => title, "url" => path + "?page=#{page}", "is_link" => true}
        end

      end
    end
  end
end