class ApplicationController < ActionController::Base
  include Shoperb::Editor::Engine.routes.url_helpers

  helper_method :current_cart

  def current_cart
    Cart.instance
  end

  def shop
    Shop.instance
  end

  def theme
    Theme.instance
  end

  def params
    env.delete "action_dispatch.request.parameters"
    super
  end
end