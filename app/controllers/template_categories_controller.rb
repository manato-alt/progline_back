class TemplateCategoriesController < ApplicationController
  def index
    begin
      categories = TemplateCategory.all
      render json: categories, status: :ok
    rescue => e
      render json: { error: "カテゴリーの取得中にエラーが発生しました: #{e.message}" }, status: :unprocessable_entity
    end
  end
end
