Rails.application.routes.draw do
  get "categories" => "categories#index"
  post "categories" => "categories#create"
  delete 'categories/:user_id/:category_id' => 'categories#delete'
  post "users" => "users#create"
  get "term_registrations" => "term_registrations#index"
  post "term_registrations" => "term_registrations#create"
end
