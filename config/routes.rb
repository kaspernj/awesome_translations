AwesomeTranslations::Engine.routes.draw do
  resources :caches

  resources :handlers, only: [:index, :show] do
    post :update_cache, on: :collection
    post :update_groups_cache, on: :member

    resources :groups, only: [:show, :update]
  end

  resources :migrations, only: [:new, :create]

  root to: "handlers#index"
end
