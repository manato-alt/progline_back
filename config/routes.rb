Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  post "categories" => "categories#create"
  delete 'categories/:user_id/:category_id' => 'categories#delete'
  post "users" => "users#create"
  get "term_registrations" => "term_registrations#index"
  post "term_registrations" => "term_registrations#create"
  put 'categories/:user_id/:category_id' => 'categories#update'
  resources :services, only: [:index]
  get "service_registrations" => "service_registrations#index"
  post "service_registrations" => "service_registrations#create"
end
