Rails.application.routes.draw do
  devise_for :installs
  devise_for :users
  root to: 'tweets#index'
  resources :tweets do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    collection do
      get 'search'
      get :drafts # /tweets/drafts へのルーティング
    end
  end
  resources :users, only: :show
  get '/favorites', to: 'tweets#favorites', as: 'favorites_list' # tweets#favorites に変更
end
