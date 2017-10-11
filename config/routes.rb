Rails.application.routes.draw do
  resources :line_item_salidas
  resources :cart_salidas
  resources :partidas
  resources :entradas do
    get :reporte, on: :member
    get :numero_entrada_cliente, on: :collection
  end
  resources :drivers
  resources :clients

  root "entradas#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
