class Store::CategoriesController < ApplicationController
  def show
    @category = Category.all.detect { |c| c.id.to_s == params[:id] }
    render :liquid => :category, :category => @category, :meta => @category
  end
end