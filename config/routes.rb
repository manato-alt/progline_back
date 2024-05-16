Rails.application.routes.draw do
  get 'shared_codes/index'
  get "template_categories" => "template_categories#index"
  resources :categories, only: [:index, :show]
  delete 'categories/:category_id' => 'categories#delete'
  put 'categories/:category_id' => 'categories#update'
  post "template_categories" => "categories#create_template"
  post "categories" => "categories#create"

  get "services" => "services#index"
  get "template_services" => "template_services#index"
  delete 'services/:service_id' => 'services#delete'
  put 'services/:service_id' => 'services#update'
  post "services_template" => "services#create_template"
  post "services" => "services#create"

  get "contents" => "contents#index"
  delete 'contents/:content_id/' => 'contents#delete'
  post "contents_custom" => "contents#create_custom"
  post "contents" => "contents#create"

  resources :graphs, only: [:index]

  resources :shared_codes, only: [:index] do
    post 'create_name', on: :collection
    post 'create_code', on: :collection
    delete 'delete_code', on: :collection
  end


  # resources :categories, only: [:index, :show]
  # post "categories" => "categories#create"
  # post "categories_template" => "categories#create_template"
  # delete 'categories/:user_id/:category_id' => 'categories#delete'
  # post "users" => "users#create"
  # get "term_registrations" => "term_registrations#index"
  # post "term_registrations" => "term_registrations#create"
  # put 'categories/:user_id/:category_id' => 'categories#update'
  # resources :services, only: [:index]
  # get "service_registrations" => "service_registrations#index"
  # post "service_registrations" => "service_registrations#create"
  # delete 'services/:user_id/:service_id' => 'services#delete'
  # post "services" => "services#create"
  # post "services_template" => "services#create_template"
  # put 'services/:user_id/:service_id' => 'services#update'
  # post "contents" => "contents#create"
  # post "contents_custom" => "contents#create_custom"
  # get "contents" => "contents#index"
  # delete 'contents/:content_id/' => 'contents#delete'
  # get "template_categories" => "template_categories#index"

  
end
