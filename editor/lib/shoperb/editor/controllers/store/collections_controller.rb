class Store::CollectionsController < ApplicationController

  def show
    @collection = Collection.all.detect { |c| c.id.to_s == params[:id] }
    render :liquid => :collection, :collection => @collection, :meta => @collection
  end

end
