class ProductsController < ApplicationController
  def show
    product   = Product.all.find { |p| p.id.to_s == params[:id] }
    @product  = ProductDrop.new(product)
    render :liquid => :product, :product => @product, :category => @category, :meta => @product
  end
end