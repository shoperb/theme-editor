class Store::PagesController < ApplicationController
  def show
    @page = Page.all.detect { |c| c.id.to_s == params[:id] }

    render :liquid => @page.template, :page => @page, :meta => @page
  end
end