class ServicesController < ApplicationController
  def index
    services = TemplateService.all
    render json: services
  end

  def create_template
    Service.transaction do
      user = User.find_by(uid: params[:user_id])
      category = Category.find_by(id: params[:category_id])
      service_template = TemplateService.find_by(id: params[:service_id])
      service = Service.new(name: service_template.name)
      
      if service.save        
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

  def create
    Service.transaction do
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

  def update
    Service.transaction do
      user = User.find_by(uid: params[:user_id])
      service = user.services.find(params[:service_id])
      if service.update(service_params)
        # 画像ファイルがアップロードされた場合は、画像をアタッチしてURLを更新
        if params[:image_file].present?
          service.image.attach(params[:image_file])
          service.update(image_url: url_for(service.image))
        end
        
        # 成功時のレスポンス
        render json: { message: "サービスの更新が成功しました" }, status: :ok
      else
        # エラー時のレスポンス
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
      service.destroy
    end
  
    render json: { message: "Service deleted successfully" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
  def service_params
    params.permit(:name)
  end



end
