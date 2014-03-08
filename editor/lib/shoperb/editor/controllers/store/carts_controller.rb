class Store::CartsController < ApplicationController

  respond_to :html
  respond_to :json, :only => [:show, :add, :update]

  def checkout
    redirect_to store_root_path
  end

  def show
    respond_to do |format|
      format.html { render :liquid => :cart }
      format.json { render :layout => false }
    end
  end

  def add
    respond_to do |format|
      format.html { redirect_to store_cart_path }
      format.json { render :action => :show, :layout => false }
    end
  end

  def update
    respond_to do |format|
      format.html { redirect_to store_cart_path }
      format.json { render :action => :show, :layout => false }
    end
  end
end