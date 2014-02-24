require 'action_controller'
ActionController::Renderers.add :liquid do |template, options|

  options.reverse_merge!(
    :errors       => CollectionDrop.new(flash[:errors]),
    :meta         => MetaDrop.new(options.delete(:meta)),
    :categories   => CategoriesDrop.new(Category.all),
    :cart         => CartDrop.new(current_cart),
    :menus        => MenusDrop.new,
    :pages        => PagesDrop.new,
    :search       => SearchDrop.new(params[:query]),
    :shop         => ShopDrop.new(shop),
    :current_page => params[:page].to_i,
    :path         => request.path,
    :params       => params,
    :template_name=> template.to_s,
    :url          => UrlDrop::Get.new,
    :form_actions => UrlDrop::Post.new,
  )
  self.content_type = request.format
  self.response_body = theme.render(template, options, self)
end