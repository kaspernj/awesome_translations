AwesomeTranslations::Engine.routes.draw do
  resources :caches

  resources :handlers, only: [:index, :show] do
    resources :groups, only: [:show, :update]
  end

  resources :migrations, only: [:new, :create]

  root to: "handlers#index"
end
