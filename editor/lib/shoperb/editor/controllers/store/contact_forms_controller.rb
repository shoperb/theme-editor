class Store::ContactFormsController < ApplicationController
  def create
    redirect_to back_url.to_s
  end

  alias :view   :create
  alias :update :create

  private
  def back_url
    uri =  URI.parse(request.headers["Referer"])
    new_query_ar = URI.decode_www_form(uri.query.to_s) << ["contact_posted", "true"]
    uri.query = URI.encode_www_form(new_query_ar)
    uri
  end
end