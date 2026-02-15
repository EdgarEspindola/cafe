Rails.application.routes.draw do
  devise_for :users, path: 'accounts', path_names: {sign_in: 'login', sign_out: 'logout' }
  
  resources :salida_procesos do
    get :reporte, on: :member
  end
  
  resources :salida_bodegas do
    get :reporte, on: :member
  end
  
  resources :line_item_salida_procesos, only: :create
  
  resources :line_item_salida_bodegas, only: :create
  
  resources :cart_salida_procesos, only: :destroy
  
  resources :cart_salida_bodegas, only: :destroy
  
  resources :entradas do
    get :reporte, on: :member
    get :numero_entrada_cliente, on: :collection
    get :excel_export, on: :collection
  end
  
  resources :drivers
  
  resources :clients
  
  resources :mermas
  
  resources :process_results

  root "entradas#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
