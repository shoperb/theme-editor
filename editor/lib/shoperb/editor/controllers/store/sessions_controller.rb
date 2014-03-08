class Store::SessionsController < ApplicationController

  def new
    render :liquid => :login
  end


  def create
  end


  def destroy
  end

end
