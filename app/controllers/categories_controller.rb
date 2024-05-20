class CategoriesController < ApplicationController
  def index
    user = User.find_by(uid: params[:user_id])
    if user
      categories = user.categories
      render json: categories
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def show
    category = Category.find_by(id: params[:id])
    render json: category
  end

  def create_template
    user = User.find_by(uid: params[:user_id])
  
    if user.nil?
      render json: { error: "ユーザーが見つかりません" }, status: :not_found and return
    end

    category_template = TemplateCategory.find_by(id: params[:category_id])
    
    if category_template.nil?
      render json: { error: "テンプレートカテゴリーが存在しません" }, status: :not_found and return
    end

    category = Category.new(name: category_template.name, image_url: category_template.image_url, user_id: user.id)

    if category.save
      render json: { message: "カテゴリーを登録しました", category: category }, status: :created
    else
      render json: { error: category.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def create
    user = User.find_by(uid: params[:user_id])
  
    if user.nil?
      render json: { error: "ユーザーが見つかりません" }, status: :not_found and return
    end

    category = Category.new(category_params.merge(user_id: user.id))

    if params[:image_file].present?
      category.image.attach(params[:image_file])
    end

    if category.save
      # Active Storageによって生成された画像のURLをimage_urlカラムに保存する
      category.update(image_url: url_for(category.image)) if category.image.attached?
      render json: { message: "カテゴリーが正常に作成されました", category: category }, status: :created
    else
      render json: { error: category.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    Category.transaction do
      category = Category.find_by(id: params[:category_id])
      if category_params[:name].blank?
        render json: { error: "名称は空にできません" }, status: :unprocessable_entity
        return
      end
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
      category = Category.find_by(id: params[:category_id])  
      # ユーザーとカテゴリーに関連する用語登録を取得し削除
      category.image.purge_later if category.image.attached?
      category.destroy
    end
    render json: { message: "正常に削除されました" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
  def category_params
    params.permit(:name)
  end
end
