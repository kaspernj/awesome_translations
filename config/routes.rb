AwesomeTranslations::Engine.routes.draw do
  resources :handlers, only: [:index, :show, :update]

  root to: "handlers#index"
end
