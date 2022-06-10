Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'greed_sessions#index'

  resources :articles do
    resources :comments, only: [:create, :destroy]
  end

  # TODO: try moving the following actions inside `:greed_sessions'
  post '/greed_sessions/:id/roll' => 'greed_sessions#roll'
  post '/greed_sessions/:id/pass' => 'greed_sessions#pass'

  resources :greed_sessions do
    # resources :greed_rolls
  end
end
