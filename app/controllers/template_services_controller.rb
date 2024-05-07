class TemplateServicesController < ApplicationController
  def index
    services = TemplateService.all
    render json: services
  end
end
