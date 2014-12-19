Rails.application.routes.draw do
  mount AwesomeTranslations::Engine => "/awesome_translations" if Rails.env.development?

  resources :locales
  resources :users
  root to: "users#index"
end
