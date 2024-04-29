class ContentsController < ApplicationController

  include LinkPreviewHelper

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
end
