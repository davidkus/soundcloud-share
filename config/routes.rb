Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  get '/help', to: 'help#index'

  get '/s(/:code)', to: 'access#grant_access', as: 'share'

  resources :rooms do
    resources :sharing_codes, only: [:index, :new, :show, :create, :destroy]
  end

end
