Rails.application.routes.draw do
  get "categories" => "categories#index"
  post "users" => "users#create"
  post "term_registrations" => "term_registrations#create"
end
