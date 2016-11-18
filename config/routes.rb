Rails.application.routes.draw do
  root 'pages#index'

  resources :parcel_entries
  resources :parcels
  resources :liens
  resources :trust_deeds

  resources :death_certificate_leads do
    get :letter, on: :member
  end

  resources :notice_of_default_leads do
    get :letter, on: :member
  end

end
