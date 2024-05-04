class ContentsController < ApplicationController
  include LinkPreviewHelper

  def index
    begin
      user = User.find_by(uid: params[:user_id])
  
      if user.nil?
        render json: { error: "User not found" }, status: :not_found
        return
      end
  
      contents = user.contents.where(service_id: params[:service_id])
      render json: contents, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def create
    metadata = fetch_metadata(params[:url])
    user = User.find_by(uid: params[:user_id])
    if metadata.present?
      content = Content.new(metadata)
      content.user_id = user.id
      content.service_id = params[:service_id]
      if content.save
        render json: { message: 'Content created successfully', content: content }, status: :created
      else
        render json: { error: 'Failed to save content' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Failed to fetch metadata' }, status: :unprocessable_entity
    end
  end

  def create_custom
    Content.transaction do
      user = User.find_by(uid: params[:user_id])
      service = Service.find_by(id: params[:service_id])
      content = Content.new(content_params)
      content.user_id = user.id
      content.service_id = service.id
      content.image.attach(params[:image_file])
      
      if content.save
        # Active Storageによって生成された画像のURLをimage_urlカラムに保存する
        content.update(image_url: url_for(content.image))
        
        unless content.save
          raise ActiveRecord::Rollback
        end
        render json: { message: "コンテンツの登録が成功しました" }, status: :created
      else
        render json: content.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def content_params
    params.permit(:title, :description, :url)
  end
end
