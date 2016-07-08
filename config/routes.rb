AwesomeTranslations::Engine.routes.draw do
  resources :caches
  resources :clean_ups, only: [:new, :create]
  resources :duplicates, only: [:index, :create]

  resources :handlers, only: [:index, :show] do
    post :update_cache, on: :collection
    post :update_groups_cache, on: :member

    resources :groups, only: [:show, :update] do
      post :update_translations_cache, on: :member
    end
  end

  resources :handler_translations, only: :index
  resources :migrations, only: [:new, :create]
  resources :movals, only: [:index, :create]

  root to: "handlers#index"
end
