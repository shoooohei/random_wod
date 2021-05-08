Rails.application.routes.draw do
  resources :instagram_wods, only: [:new, :create]
  resources :wodify_wods, only: [:new, :create]
  resources :wods, only: [:index, :show] do
    resources :logs
  end
  namespace :api, defaults: { format: :json} do
    namespace :v1 do
      post 'create_maebashi_wod', to: 'maebashi_wods#create'
    end
  end
  root 'wods#index'
end
