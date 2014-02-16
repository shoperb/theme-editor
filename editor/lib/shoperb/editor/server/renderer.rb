module Shoperb::Editor
  class Server

    class Renderer < Middleware

      def call(env)
        self.set_accessors(env)

        if self.page
          type = 'text/html'
          html = self.render_page

          self.log "  Rendered liquid page template"

          [200, { 'Content-Type' => type }, [html]]
        else
          [404, { 'Content-Type' => 'text/html' }, [self.render_404]]
        end
      end

      protected

      def render_page
        context = self.shoperb_context
        begin
          self.page.render context
        rescue Exception => e
          raise e
          raise RendererException.new(e, self.page.title, self.page.template, context)
        end
      end

      def render_404
        if self.page = self.mounting_point.templates['not-found']
          self.render_page
        else
          'Page not found'
        end
      end

      # Build the Liquid context used to render the Shoperb page. It
      # stores both assigns and registers.
      #
      # @param [ Hash ] other_assigns Assigns coming for instance from the controler (optional)
      #
      # @return [ Object ] A new instance of the Liquid::Context class.
      #
      def shoperb_context(other_assigns = {})
        assigns = self.shoperb_default_assigns

        # assigns from other middlewares
        assigns.merge!(self.liquid_assigns)

        assigns.merge!(other_assigns)

        # templatized page
        if self.page && self.content_entry
          ['content_entry', 'entry', self.page.content_type.slug.singularize].each do |key|
            assigns[key] = self.content_entry
          end
        end

        # Tip: switch from false to true to enable the re-thrown exception flag
        ::Liquid::Context.new({}, assigns, self.shoperb_default_registers, true)
      end

      # Return the default Liquid assigns used inside the Shoperb Liquid context
      #
      # @return [ Hash ] The default liquid assigns object
      #
      def shoperb_default_assigns
        {
          :search       => SearchDrop.new(params[:query]),
          :menus        => MenusDrop.new,
          :pages        => PagesDrop.new,
          :categories   => CategoriesDrop.new(categories),
          :shop         => ShopDrop.new(shop),
          :cart         => CartDrop.new(cart),
          :current_page => params[:page].to_i,
          :path         => request.path,
          :params       => params,
          :orders       => CollectionDrop.new(orders),
          :order        => OrderDrop.new(orders.first),
          :order_items  => CollectionDrop.new(order_items)
        }.stringify_keys
      end

      # Return the default Liquid registers used inside the Shoperb Liquid context
      #
      # @return [ Hash ] The default liquid registers object
      #
      def shoperb_default_registers
        self.mounting_point.resources.merge(
          request:        self.request,
          mounting_point: self.mounting_point,
          inline_editor:  false,
          logger:         Shoperb::Editor::Logger
        )
      end

    end

  end
end