Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'articles#index'

  resources :articles do
    resources :comments
  end

  resources :greed_sessions do
    # resources :greed_rolls

    post 'roll' => 'greed_sessions#roll'
  end
end
