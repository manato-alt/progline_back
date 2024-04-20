service_names = ['Youtube', 'Udemy', 'Qiita', 'Zenn', '書籍']

# サービスを登録
service_names.each do |name|
  Service.create!(name: name)
end