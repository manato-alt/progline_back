class ServiceRegistrationsController < ApplicationController
  def index
    # ユーザーを取得
    user = User.find_by(uid: params[:user_id])
    # ユーザーが存在しない場合の処理
    return render json: { error: "User not found" }, status: :not_found if user.nil?
  
    # カテゴリーを取得
    category = Category.find_by(id: params[:category_id])
    # カテゴリーが存在しない場合の処理
    return render json: { error: "Category not found" }, status: :not_found if category.nil?
  
    # ユーザーとカテゴリーに紐づくサービスを取得
    services = Service.joins(:service_registrations).where(service_registrations: { user_id: user.id, category_id: category.id })  

    # サービス一覧をビューに渡す
    render json: services
  end

  def create
    # ログインユーザーを取得
    user = User.find_by(uid: params[:user_id])

    # 選択されたカテゴリを取得
    category = Category.find_by(id: params[:category_id])

    service = Service.find_by(id: params[:service_id])

    # 登録処理
    service_registration = ServiceRegistration.new(user_id: user.id, category_id: category.id, service_id: service.id)

    if service_registration.save
      render json: { message: "サービスの登録が成功しました" }, status: :created
    else
      render json: { errors: service_registration.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
