Rails.application.routes.draw do
  get 'categories/index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :restaurant_users, skip: %i[registrations sessions passwords]
  devise_scope :restaurant_user do
    post '/restaurant_users/login', to: 'restaurant_sessions#create'
    post '/restaurant_users/two_factor', to: 'restaurant_sessions#two_factor'
    post '/restaurant_users/request_two_factor', to: 'restaurant_sessions#request_two_factor'
    delete '/restaurant_users/sign_out', to: 'restaurant_sessions#destroy'
    post '/restaurant_users/password', to: 'restaurant_passwords#create'
    put '/restaurant_users/password', to: 'restaurant_passwords#update'
    get '/restaurant_users/accept_invite', to: 'restaurant_invitations#edit'
    post '/restaurant_users/invite', to: 'restaurant_invitations#create'
    put '/restaurant_users/confirm_invite', to: 'restaurant_invitations#update'
  end

  devise_for :customers, skip: %i[registrations sessions passwords]
  devise_scope :customer do
    post '/customers/sign_up', to: 'customer_registrations#create'
    post '/customers/sign_in', to: 'customer_sessions#create'
    delete '/customers/sign_out', to: 'customer_sessions#destroy'
    post '/customers/password', to: 'customer_passwords#create'
    put '/customers/password', to: 'customer_passwords#update'
  end

  resources :restaurants, only: [:create, :index, :show, :update] do
    resources :purchases, only: [:index, :show], module: 'restaurants' do
      put :delivered, on: :member
      get :by_code, on: :collection
    end
  end

  root to: 'home#index'
end
