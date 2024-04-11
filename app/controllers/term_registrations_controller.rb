class TermRegistrationsController < ApplicationController
  def create
    # ログインユーザーを取得
    user = User.find_by(uid: params[:user_id])

    # 選択されたカテゴリを取得
    category = Category.find(params[:category_id])

    # 登録処理
    term_registration = TermRegistration.new(user_id: user.id, category_id: category.id)

    if term_registration.save
      render json: { message: "カテゴリの登録が成功しました" }, status: :created
    else
      render json: term_registration.errors, status: :unprocessable_entity
    end
  end
end