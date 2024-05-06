Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  post "categories" => "categories#create"
  post "categories_template" => "categories#create_template"
  delete 'categories/:user_id/:category_id' => 'categories#delete'
  post "users" => "users#create"
  get "term_registrations" => "term_registrations#index"
  post "term_registrations" => "term_registrations#create"
  put 'categories/:user_id/:category_id' => 'categories#update'
  resources :services, only: [:index]
  get "service_registrations" => "service_registrations#index"
  post "service_registrations" => "service_registrations#create"
  delete 'services/:user_id/:category_id/:service_id' => 'services#delete'
  post "services" => "services#create"
  post "services_template" => "services#create_template"
  put 'services/:user_id/:service_id' => 'services#update'
  post "contents" => "contents#create"
  post "contents_custom" => "contents#create_custom"
  get "contents" => "contents#index"
  delete 'contents/:content_id/' => 'contents#delete'

  
end
