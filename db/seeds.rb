require 'httparty'

service_names = ['Youtube', 'Udemy', 'Qiita', 'Zenn', '書籍']

# サービスを登録
service_names.each do |name|
  TemplateService.find_or_create_by(name: name)
end

response = HTTParty.get("https://qiita.com/api/v2/tags?page=1&per_page=50&sort=count")
tags_data = response.parsed_response

# 上位30件のタグデータを取得してデータベースに保存
tags_data.first(50).each do |tag|
  unless TemplateCategory.exists?(name: tag['id'])
    TemplateCategory.create(name: tag['id'], image_url: tag['icon_url'])
  end
end