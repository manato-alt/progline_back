class SharedCodesController < ApplicationController
  def index
    begin
      user = User.find_by(uid: params[:user_id])
      if user
        shared_code = user.shared_code
        render json: shared_code, status: :ok
      else
        render json: { error: "指定されたユーザーが見つかりませんでした" }, status: :not_found
      end
    rescue => e
      render json: { error: "共有コードの取得中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def create_name
    begin
      user = User.find_by(uid: params[:user_id])
      if user
        shared_code = user.shared_code || SharedCode.new(user: user)
        if shared_code.update(public_name: params[:public_name])
          render json: { message: "公開名を更新しました" }, status: :ok
        else
          render json: { error: shared_code.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      else
        render json: { error: "指定されたユーザーが見つかりませんでした" }, status: :not_found
      end
    rescue => e
      render json: { error: "公開名の更新中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def create_code
    begin
      user = User.find_by(uid: params[:user_id])
      if user
        shared_code = user.shared_code || SharedCode.new(user: user)
        # public_nameが空の場合のみ、auth.currentUser.displayNameを設定する
        if shared_code.public_name.blank?
          shared_code.public_name = params[:public_name]
        end
        if shared_code.save && shared_code.update(code: generate_unique_code)
          render json: { message: "コードが正常に生成されました", shared_code: shared_code }, status: :ok
        else
          render json: { error: "コードの生成に失敗しました" }, status: :unprocessable_entity
        end
      else
        render json: { error: "ユーザーが見つかりませんでした" }, status: :not_found
      end
    rescue => e
      render json: { error: "コードの生成中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def delete_code
    begin
      user = User.find_by(uid: params[:user_id])
      if user
        if user.shared_code.update(code: nil)
          render json: { message: "コードが正常に削除されました", shared_code: user.shared_code }, status: :ok
        else
          render json: { error: "コードの削除に失敗しました" }, status: :unprocessable_entity
        end
      else
        render json: { error: "ユーザーが見つかりませんでした" }, status: :not_found
      end
    rescue => e
      render json: { error: "コードの削除中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def search
    begin
      shared_code = SharedCode.find_by(code: params[:code])
      if shared_code
        render json: { public_name: shared_code.public_name }, status: :ok
      else
        render json: { error: "指定されたシェアコードが見つかりません" }, status: :not_found
      end
    rescue => e
      render json: { error: "シェアコードの検索中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def term_index
    begin
      # params[:code]からshared_codeを探す
      shared_code = SharedCode.find_by(code: params[:code])
  
      if shared_code
        # shared_codeからuserを取得
        user = shared_code.user
        categories = user.categories
        render json: categories
      else
        render json: { error: "指定されたユーザーが見つかりません" }, status: :not_found
      end
    rescue => e
      render json: { error: "用語を取得中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def graph
    begin
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
    rescue => e
      render json: { error: "グラフデータの取得中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  def service_index
    begin
      category = Category.find_by(id: params[:category_id])
      if category
        services = category.services
        render json: services
      else
        render json: { error: "指定されたカテゴリーが見つかりません" }, status: :not_found
      end
    rescue => e
      render json: { error: "サービスの取得中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end

  private

  def generate_unique_code
    SecureRandom.hex(10)
  end

end
