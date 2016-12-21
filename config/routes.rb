Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#index'

  resources :parcel_entries
  resources :parcels
  resources :liens
  resources :trust_deeds

  resources :leads do
    get :letter, on: :member
    post :send_letter, on: :member
    get :hide, on: :member
  end

end
