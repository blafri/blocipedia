Rails.application.routes.draw do
  root 'static_pages#homepage'
  
  devise_for :users, controllers: {registrations: 'users'}
  devise_scope :user do
    post 'users/password/reset', to: 'users#password_reset', as: :reset_user_password
  end
  
  resources :wikis
  
  # routes for account upgrades using paypal
  get "upgrade", to: "charges#index"
  post "upgrade", to: "charges#create"
  get "upgrade/confirm_payment", to: "charges#confirm_payment"
  post "upgrade/confirm_payment", to: "charges#make_payment"
  post "upgrade/refund", to: "charges#refund_payment"
end
