Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :restaurant_users, skip: %i[registrations sessions passwords]
  devise_scope :restaurant_user do
    post '/restaurant_users/sign_up', to: 'restaurant_registrations#create'
    post '/restaurant_users/login', to: 'restaurant_sessions#create'
    post '/restaurant_users/two_factor', to: 'restaurant_sessions#two_factor'
    delete '/restaurant_users/sign_out', to: 'restaurant_sessions#destroy'
  end

  devise_for :customers, skip: %i[registrations sessions passwords]
  devise_scope :customer do
    post '/customers/sign_up', to: 'registrations#create'
    post '/customers/sign_in', to: 'sessions#create'
    delete '/customers/sign_out', to: 'sessions#destroy'
  end

  root to: 'home#index'
end
