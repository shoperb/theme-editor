class Store::IndexController < ApplicationController
  def index
    render :liquid => :index
  end
end