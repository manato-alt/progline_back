class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories
  end

  def create
    Category.transaction do
      user = User.find_by(uid: params[:user_id])
      category = Category.new(category_params)
      category.image.attach(params[:image_file])
      
      if category.save
        # Active Storageによって生成された画像のURLをimage_urlカラムに保存する
        category.update(image_url: url_for(category.image))
        
        term_registration = TermRegistration.new(user_id: user.id, category_id: category.id)
        unless term_registration.save
          raise ActiveRecord::Rollback
        end
        render json: { message: "カテゴリの登録が成功しました" }, status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
  def category_params
    params.permit(:name, :is_original)
  end
end
