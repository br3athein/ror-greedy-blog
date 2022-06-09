Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"

  resources :articles do
    resources :comments
  end

  get '/greed', to: 'greed#interface'
  post '/greed/roll', to: 'greed#roll'
  get '/greed/rules', to: 'greed#rules'
end
