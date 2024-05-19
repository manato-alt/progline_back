class SharedCodesController < ApplicationController
  def index
    user = User.find_by(uid: params[:user_id])
    shared_code = user.shared_code

    render json: shared_code, status: :ok
  end

  def create_name
    user = User.find_by(uid: params[:user_id])
    if user
      shared_code = user.shared_code || SharedCode.new(user: user)
      if shared_code.update(public_name: params[:public_name])
        render json: { message: "Public name updated successfully" }, status: :ok
      else
        render json: { error: shared_code.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def create_code
    user = User.find_by(uid: params[:user_id])
    if user
      shared_code = user.shared_code || SharedCode.new(user: user)
      # public_nameが空の場合のみ、auth.currentUser.displayNameを設定する
      if shared_code.public_name.blank?
        shared_code.public_name = params[:public_name]
      end
      if shared_code.save && shared_code.update(code: generate_unique_code)
        render json: { message: "Code generated successfully", shared_code: shared_code }, status: :ok
      else
        render json: { error: "Failed to generate code" }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def delete_code
    user = User.find_by(uid: params[:user_id])
    if user
      if user.shared_code.update(code: nil)
        render json: { message: "Code deleted successfully", shared_code: user.shared_code }, status: :ok
      else
        render json: { error: "Failed to delete code" }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def search
    shared_code = SharedCode.find_by(code: params[:code])
    if shared_code
      render json: { public_name: shared_code.public_name }, status: :ok
    else
      render json: { error: "シェアコードが見つかりません" }, status: :not_found
    end
  end

  def term_index
    # params[:code] から shared_code を探す
    shared_code = SharedCode.find_by(code: params[:code])
    
    if shared_code
      # shared_code から user を取得
      user = shared_code.user
      categories = user.categories
      render json: categories
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def graph
    shared_code = SharedCode.find_by(code: params[:code])
    user = shared_code.user
    if user
      categories = user.categories.includes(services: :contents)
    else
      categories = [] # ユーザーが存在しない場合は空の配列を返す
    end
    graph_data = categories.map do |category|
      {
        label: category.name, # カテゴリー名
        data: category.services.sum { |service| service.contents.count } # カテゴリーに関連するコンテンツの合計数
      }
    end
    render json: graph_data
  end

  def service_index
    category = Category.find_by(id: params[:category_id])
    services = category.services
    render json: services
  end

  def content_index
  end

  private

  def generate_unique_code
    SecureRandom.hex(10)
  end

end
