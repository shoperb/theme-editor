class IndexController < ApplicationController
  def index
    render :liquid => :index
  end
end