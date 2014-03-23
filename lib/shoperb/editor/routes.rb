module Shoperb
  module Editor
    module Routes
      def self.registered(app)
        app.before '/:locale/*' do
          I18n.locale =
          if Language.all.map(&:code).include?(params[:locale])
            request.path_info = '/' + params[:splat ][0]
            params[:locale]
          elsif (shop = Shop.instance) && shop.language_code
            shop.language_code
          end
        end

        app.get '/' do
          render_liquid :index
        end

        app.get '/*/*' do |model, id|
          return if model == '__sinatra__'
          render_liquid model.singularize.to_sym, locals: { model.singularize.to_sym => model.singularize.classify.constantize.find(id) }, scope: shoperb_default_assigns
        end
      end
    end
  end
end