class ServicesController < ApplicationController
  def index
    services = Service.where(is_original: false)
    render json: services
  end

  def create
    Category.transaction do
      user = User.find_by(uid: params[:user_id])
      category = Category.find_by(id: params[:category_id])
      service = Service.new(service_params)
      service.image.attach(params[:image_file])
      
      if service.save
        # Active Storageによって生成された画像のURLをimage_urlカラムに保存する
        service.update(image_url: url_for(service.image))
        
        service_registration = ServiceRegistration.new(user_id: user.id, category_id: category.id, service_id: service.id)
        unless service_registration.save
          raise ActiveRecord::Rollback
        end
        render json: { message: "サービスの登録が成功しました" }, status: :created
      else
        render json: service.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity

  end

  def delete
    ActiveRecord::Base.transaction do
      # パラメータからユーザーとカテゴリーを取得
      user = User.find_by(uid: params[:user_id])
      category = Category.find_by(id: params[:category_id])
      service = Service.find_by(id: params[:service_id])

  
      # ユーザーとカテゴリーに関連する用語登録を取得し削除
      service_registration = ServiceRegistration.find_by(user_id: user.id, category_id: category.id, service_id: service.id)
      service_registration.destroy if service_registration
  
      # カテゴリーがオリジナルであれば削除
      service.destroy if service&.is_original?
    end
  
    render json: { message: "Service deleted successfully" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
  def service_params
    params.permit(:name, :is_original)
  end



end
