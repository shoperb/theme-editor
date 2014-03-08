class Store::OrdersController < ApplicationController

  def index
    orders = Order.all
    render :liquid => :orders, :orders => orders
  end


  def show
    order = Order.all.detect { |c| c.id.to_s == params[:id] }
    render :liquid => :order, :order => order
  end


end