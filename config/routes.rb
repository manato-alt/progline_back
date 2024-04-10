Rails.application.routes.draw do
  get "categories" => "categories#index"
  post "users" => "users#create"
end
