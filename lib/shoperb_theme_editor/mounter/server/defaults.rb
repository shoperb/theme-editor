Sinatra.autoload :Flash, "sinatra/flash"

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Defaults
        module Helpers

          def default_locals locals={}
            set_pagination_defaults
            {
              :errors       => Liquid::Drop::Collection.new(flash[:errors] || params[:errors] || []),
              :meta         => Liquid::Drop::Meta.new(locals.delete(:meta)),
              :categories   => Liquid::Drop::Categories.new(Model::Category.active),
              :cart         => current_cart.to_liquid,
              :menus        => Liquid::Drop::Menus.new(Model::Menu.all),
              :pages        => Liquid::Drop::Pages.new(Model::Page.active),
              :search       => Liquid::Drop::Search.new(params[:query]),
              :blog_posts   => Liquid::Drop::Collection.new(Model::BlogPost.active),
              :media_files  => Liquid::Drop::Collection.new(Model::MediaFile.all),
              :countries    => Liquid::Drop::Collection.new(Model::Country.all),
              :vendors      => Liquid::Drop::Vendors.new(Model::Vendor.all),
              :brands       => Liquid::Drop::Vendors.new(Model::Vendor.all),
              :shop         => shop.to_liquid,
              :path         => request.path,
              :params       => params,
              :get_params   => request.env['rack.request.query_hash'],
              :url          => Liquid::Drop::Url::Get.new,
              :form_actions => Liquid::Drop::Url::Post.new,
              :current_page => params["page"],
              :customer     => Liquid::Drop::Customer.new(current_customer),
              :account      => Liquid::Drop::Customer.new(current_customer),
              :collections  => Liquid::Drop::ProductCollections.new(Model::Collection.all),
              :products     => Liquid::Drop::Products.new(Model::Product.active),
              :settings     => Liquid::Drop::ThemeSettings.new(Editor.theme_settings),
              :preview      => params[:theme_id].present?,
              :edit_preview => params[:iframe_uuid].present?
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
