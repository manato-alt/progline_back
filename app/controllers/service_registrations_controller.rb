class ServiceRegistrationsController < ApplicationController
  def index
    # ユーザーとカテゴリーを取得
    user = User.find(params[:user_id])
    category = Category.find(params[:category_id])

    # ユーザーとカテゴリーに紐づくサービスを取得
    services = user.services.where(category: category)

    # サービス一覧をビューに渡す
    render json: services
  end

  def create
    # ログインユーザーを取得
    user = User.find_by(uid: params[:user_id])

    # 選択されたカテゴリを取得
    category = Category.find(params[:category_id])

    service = Service.find(params[:service_id])

    # 登録処理
    service_registration = ServiceRegistration.new(user_id: user.id, category_id: category.id, service_id: service.id)

    if service_registration.save
      render json: { message: "サービスの登録が成功しました" }, status: :created
    else
      render json: service_registration.errors, status: :unprocessable_entity
    end
  end

end
