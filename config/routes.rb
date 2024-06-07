Rails.application.routes.draw do
  post "users" => "users#create"
  get 'shared_codes/index'
  get "template_categories" => "template_categories#index"
  resources :categories, only: [:index, :show]
  delete 'categories/:category_id' => 'categories#delete'
  put 'categories/:category_id' => 'categories#update'
  post "template_categories" => "categories#create_template"
  post "categories" => "categories#create"
  post "categories/validate_access" => "categories#validate_access"

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

  post 'shared_codes/search', to: 'shared_codes#search'

  get 'shared_codes/term_index', to: 'shared_codes#term_index'
  get 'shared_codes/service_index', to: 'shared_codes#service_index'
  get 'shared_codes/graph', to: 'shared_codes#graph'
  get 'shared_codes/share_user', to: 'shared_codes#share_user'
  post "shared_codes/validate_access_term" => "shared_codes#validate_access_term"
  post "shared_codes/validate_access" => "shared_codes#validate_access"

  get '/health_check', to: 'health_checks#index'

end
