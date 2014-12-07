Sinatra.autoload :Flash, "sinatra/flash"
Sinatra.autoload :RespondWith,"sinatra/respond_with"

Tilt::Template.class_eval do
  def require_template_library(name)
    # Silence the warning
    require name
  end
end

module Shoperb module Theme module Editor
  module Mounter
    class Server < Sinatra::Base

      Editor.autoload_all self, "shoperb_theme_editor/mounter/server"

      set :root, Dir.pwd
      set :environment, :development

      use ExceptionHandler
      register Renderer
      register Routes

      helpers do
        def current_cart
          Model::Cart.instance
        end

        def shop
          Model::Shop.instance
        end
      end
    end
  end
end end end
