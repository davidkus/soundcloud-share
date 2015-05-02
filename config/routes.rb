Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  resources :rooms do
    resources :sharing, only: [:show]
  end

end
