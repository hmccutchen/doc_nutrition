Rails.application.routes.draw do
  root to: 'food_items#index'
 

  resources 'food_items'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
