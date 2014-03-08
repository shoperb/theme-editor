class Store::SearchesController < ApplicationController

  def show
    render :liquid => :search
  end

end
