class GraphsController < ApplicationController
  def index
    user = User.find_by(uid: params[:user_id]) # ユーザーIDからユーザーを取得
    if user
      categories = user.categories.includes(services: :contents) # ユーザーに関連するカテゴリー、サービス、コンテンツを一括で取得
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
end
