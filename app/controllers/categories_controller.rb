class CategoriesController < ApplicationController
  def index
    categories = Category.where(is_original: false)
    render json: categories
  end

  def show
    category = Category.find(params[:id])
    render json: category
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

  def update
    Category.transaction do
      user = User.find_by(uid: params[:user_id])
      category = user.categories.find(params[:category_id])
      if category.update(category_params)
        # 画像ファイルがアップロードされた場合は、画像をアタッチしてURLを更新
        if params[:image_file].present?
          category.image.attach(params[:image_file])
          category.update(image_url: url_for(category.image))
        end
        
        # 成功時のレスポンス
        render json: { message: "カテゴリの更新が成功しました" }, status: :ok
      else
        # エラー時のレスポンス
        render json: category.errors, status: :unprocessable_entity
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
  
      # ユーザーとカテゴリーに関連する用語登録を取得し削除
      term_registration = TermRegistration.find_by(user_id: user.id, category_id: category.id)
      term_registration.destroy if term_registration
  
      # カテゴリーがオリジナルであれば削除
      category.destroy if category&.is_original?
    end
  
    render json: { message: "Category deleted successfully" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
  def category_params
    params.permit(:name, :is_original)
  end
end
