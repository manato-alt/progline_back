class UsersController < ApplicationController
  def create
    uid = user_params[:uid]
    # UIDを持つユーザーが既に存在するかチェック
    user = User.find_by(uid: uid)
    # ユーザーが存在しない場合のみ新規作成
    if user.nil?
      user = User.create(uid: uid)
    end
  end

  private

  def user_params
    params.require(:user).permit(:uid)
  end
end
