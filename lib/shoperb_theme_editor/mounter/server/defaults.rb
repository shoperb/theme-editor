Sinatra.autoload :Flash, "sinatra/flash"

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Defaults
        module Helpers

          def default_locals locals={}
            set_pagination_defaults
            {
              :errors       => Drop::Collection.new(flash[:errors] || params[:errors] || []),
              :meta         => Drop::Meta.new(locals.delete(:meta)),
              :categories   => Drop::Categories.new(Model::Category.all),
              :cart         => current_cart.to_liquid,
              :menus        => Drop::Menus.new(Model::Menu.all),
              :pages        => Drop::Pages.new(Model::Page.all),
              :search       => Drop::Search.new(params[:query]),
              :shop         => shop.to_liquid,
              :path         => request.path,
              :params       => params,
              :get_params   => request.env['rack.request.query_hash'],
              :url          => Drop::Url::Get.new,
              :form_actions => Drop::Url::Post.new,
              :current_page => params["page"],
              :collections  => Drop::ProductCollections.new(Model::Collection.all)
            }
          end

          def set_pagination_defaults
            params["pagination"] ||= {}
            params["page"] = params["page"].present? ? params["page"].to_i : 1
            params["pagination"]["size"] ||= (1..25).to_a.sample
            min = params["page"] * params["pagination"]["size"].to_i
            params["pagination"]["total"] ||= (min..min+200).to_a.sample
            params["pagination"]["pages"] ||= (params["pagination"]["total"].to_i / params["pagination"]["size"].to_i)
            params["pagination"]["last"] ||= params["pagination"]["total"].to_i - 1
            params["pagination"]["offset"] ||= ((params["page"].to_i - 1) * params["pagination"]["size"].to_i)
          end

        end

        def self.registered app
          app.helpers Helpers
          app.register Sinatra::Flash
        end
      end
    end
  end
end end end
