class ContentsController < ApplicationController
  include LinkPreviewHelper

  def index
    service = Service.find_by(id: params[:service_id])
    contents = service.contents
    render json: contents, status: :ok
  end

  def create
    metadata = fetch_metadata(params[:url])
    if metadata.present?
      content = Content.new(metadata)
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
      service = Service.find_by(id: params[:service_id])
      content = Content.new(content_params.merge(service_id: service.id))
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

  def delete
    ActiveRecord::Base.transaction do
      # パラメータからユーザーとカテゴリーを取得
      content = Content.find_by(id: params[:content_id])
      content.image.purge_later if content.image.attached?
      content.destroy if content
    end  
    render json: { message: "Content deleted successfully" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  private

  def content_params
    params.permit(:title, :url)
  end
end
