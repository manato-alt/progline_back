class TemplateServicesController < ApplicationController
  def index
    begin
      services = TemplateService.all
      render json: services, status: :ok
    rescue => e
      render json: { error: "サービスの取得中にエラーが発生しました: #{e.message}" }, status: :unprocessable_entity
    end
  end
end
