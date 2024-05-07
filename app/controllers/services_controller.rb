class ServicesController < ApplicationController
  def index
    # カテゴリーを取得
    category = Category.find_by(id: params[:category_id])
    services = category.services
    render json: services
  end

  def create_template
    category = Category.find_by(id: params[:category_id])
    service_template = TemplateService.find_by(id: params[:service_id])
    if category && service_template
      service = Service.new(name: service_template.name, category_id: category.id)
      if service.save
        render json: { message: "Template service created successfully" }, status: :created
      else
        render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Category or service template not found" }, status: :not_found
    end
  end

  def create
    Service.transaction do
      category = Category.find_by(id: params[:category_id])
      service = Service.new(service_params.merge(category_id: category.id))
      service.image.attach(params[:image_file])
      
      if service.save
        # Active Storageによって生成された画像のURLをimage_urlカラムに保存する
        service.update(image_url: url_for(service.image))
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
      service = Service.find(params[:service_id])
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
    service = Service.find_by(id: params[:service_id])
    service.image.purge_later if service.image.attached?
    service.destroy
  end

  private
  def service_params
    params.permit(:name)
  end
end
