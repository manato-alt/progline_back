Rails.application.routes.draw do
  get "categories" => "categories#index"
  post "categories" => "categories#create"
  post "users" => "users#create"
  get "term_registrations" => "term_registrations#index"
  post "term_registrations" => "term_registrations#create"
end
