class ServicesController < ApplicationController
  def index
    services = Service.where(is_original: false)
    render json: services
  end

end
