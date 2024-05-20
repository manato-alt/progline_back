class GraphsController < ApplicationController
  def index
    begin
      user = User.find_by(uid: params[:user_id]) # ユーザーIDからユーザーを取得
      if user
        categories = user.categories.includes(services: :contents) # ユーザーに関連するカテゴリー、サービス、コンテンツを一括で取得
        graph_data = categories.map do |category|
          {
            label: category.name, # カテゴリー名
            data: category.services.sum { |service| service.contents.count } # カテゴリーに関連するコンテンツの合計数
          }
        end
        render json: graph_data, status: :ok
      else
        render json: { error: "指定されたユーザーが見つかりませんでした" }, status: :not_found
      end
    rescue => e
      render json: { error: "グラフデータの取得中にエラーが発生しました", details: e.message }, status: :unprocessable_entity
    end
  end
end
