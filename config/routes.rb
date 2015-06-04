Rails.application.routes.draw do
  root 'static_pages#homepage'
  
  devise_for :users, controllers: {registrations: 'users'}
  devise_scope :user do
    post 'users/password/reset', to: 'users#password_reset', as: :reset_user_password
  end
  
  resources :wikis
  
  resource :charge, only: [:new, :create]
  resource :refund, only: :create
  resource :upgrade, only: :show
end
