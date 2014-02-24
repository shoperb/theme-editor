require 'rails'
class Shoperb::Editor::Engine < ::Rails::Engine
end

Shoperb::Editor::Engine.routes.draw do
  scope "/(:locale)", locale: Language.all.map(&:code) do

    root :to => "index#index"

    resource :contact_form, path: "submit-form"
    resources :countries
    resources :pages, :only => :show
    resources :products, :only => [:index, :show] do
      get 'page/:page', :action => :index, :on => :collection
    end
    resources :categories, :only => :show
    resources :categories, :only => :show
    resources :collections, :only => :show
    resources :orders, :only => [:index, :show]
    resource :search

    resource :cart, :only => :show do
      post "add", on: :member
      post "update", on: :member, as: :update
      post "checkout", on: :member
    end

    get "/protected" => "protection#show", :as => :protection
    put "/protected" => "protection#update", :as => :upd_protection

    get "/login" => "sessions#new", :as => :login
    post "/login" => "sessions#create", :as => :new_login
    get "/logout" => "sessions#destroy", :as => :logout

    get "/recover" => "passwords#new", :as => :recover_password
    post "/recover" => "passwords#create", :as => :new_recover_password

    get "/reset" => "password#edit", :as => :reset_password
    get "/reset/:token" => "password#update", :as => :mail_reset_password
    post "/reset" => "password#update", :as => :upd_reset_password

    get "/:id" => "pages#show"
  end

end
