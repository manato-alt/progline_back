class ContentsController < ApplicationController
  include LinkPreviewHelper

  def index
    service = Service.find_by(id: params[:service_id])
    
    if service
      contents = service.contents
      render json: contents, status: :ok
    else
      render json: { error: "サービスが見つかりません" }, status: :not_found
    end
  rescue => e
    render json: { error: "コンテンツの取得中にエラーが発生しました: #{e.message}" }, status: :unprocessable_entity
  end

  def create
    begin
      metadata = fetch_metadata(params[:url])
      if metadata.present?
        content = Content.new(metadata)
        content.service_id = params[:service_id]
        if content.save
          render json: { message: 'コンテンツが正常に作成されました', content: content }, status: :created
        else
          render json: { error: 'コンテンツの保存に失敗しました', details: content.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'メタデータの取得に失敗しました' }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: 'コンテンツの作成中にエラーが発生しました', details: e.message }, status: :unprocessable_entity
    end
  end

  def create_custom
    service = Service.find_by(id: params[:service_id])
    content = Content.new(content_params.merge(service_id: service.id))

    if content.save
      render json: { message: "コンテンツの登録が成功しました" }, status: :created
    else
      render json: { error: "コンテンツの保存に失敗しました", details: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    begin
      ActiveRecord::Base.transaction do
        # パラメータからユーザーとカテゴリーを取得
        content = Content.find_by(id: params[:content_id])
        if content
          content.destroy
          render json: { message: "コンテンツが正常に削除されました" }, status: :ok
        else
          render json: { error: "指定されたコンテンツが見つかりませんでした" }, status: :not_found
        end
      end  
    rescue => e
      render json: { error: "コンテンツの削除中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end


  private

  def content_params
    params.require(:content).permit(:title, :image, :url)
  end
end
