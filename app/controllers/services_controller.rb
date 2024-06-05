class ServicesController < ApplicationController
  def index
    # カテゴリーを取得
    category = Category.find_by(id: params[:category_id])
    
    if category.nil?
      render json: { error: "カテゴリが見つかりません" }, status: :not_found
    else
      services = category.services
      render json: services
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def create_template
    begin
      ActiveRecord::Base.transaction do
        category = Category.find_by(id: params[:category_id])
        service_template = TemplateService.find_by(id: params[:service_id])
        
        if category.nil?
          render json: { error: "カテゴリが見つかりません" }, status: :not_found
          raise ActiveRecord::Rollback
        end
        
        if service_template.nil?
          render json: { error: "サービステンプレートが見つかりません" }, status: :not_found
          raise ActiveRecord::Rollback
        end
        
        service = Service.new(name: service_template.name, category_id: category.id)
        if service.save
          render json: { message: "テンプレートサービスが正常に作成されました" }, status: :created
        else
          render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def create
    category = Category.find_by(id: params[:category_id])
    if category.nil?
      render json: { error: "カテゴリが見つかりません" }, status: :not_found and return
    end
    
    service = Service.new(service_params.merge(category_id: category.id))
    
    if service.save
      render json: { message: "サービスの登録が成功しました" }, status: :created
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    Service.transaction do
      service = Service.find(params[:service_id])
      if service.update(service_params)
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
    begin
      service = Service.find_by(id: params[:service_id])
      
      if service.nil?
        render json: { error: "サービスが見つかりません" }, status: :not_found
        return
      end
      
      service.destroy
      
      render json: { message: "サービスが正常に削除されました" }, status: :ok
    rescue => e
      render json: { error: "サービスの削除中にエラーが発生しました: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def service_params
    params.require(:service).permit(:name, :image)
  end
end
