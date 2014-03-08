class ApplicationController < ActionController::Base
  include Shoperb::Editor::Engine.routes.url_helpers

  before_filter :set_locale

  helper_method :current_cart

  def set_locale
    params[:locale] = (Language.all.map(&:code) & [params[:locale]]).first
    Globalize.locale = I18n.locale = params[:locale] || Shop.instance.language_code
  end

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

  def default_url_options(options = {})
    {locale: params[:locale]}
  end
end