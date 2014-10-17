AwesomeTranslations::Engine.routes.draw do
  resources :handlers, only: [:index, :show]

  root to: "handlers#index"
end
