Rails.application.routes.draw do
  devise_for :users
  root to: 'food_items#index'
 

  resources 'food_items'
  
  resources 'users' do
    get "/food_items", to: "food_items#user_food_index"
    resources 'food_items' 
end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
