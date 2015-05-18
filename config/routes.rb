Rails.application.routes.draw do
  root 'static_pages#homepage'
  
  devise_for :users, controllers: {registrations: 'users'}
  devise_scope :user do
    post 'users/password/reset', to: 'users#password_reset', as: :reset_user_password
  end
end
