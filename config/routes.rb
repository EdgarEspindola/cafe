Rails.application.routes.draw do
  resources :partidas
  resources :entradas do
    get :reporte, on: :member
  end
  resources :drivers
  resources :clients

  root "entradas#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
