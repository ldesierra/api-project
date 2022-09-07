Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :customers, skip: %i[regsitrations sessions passwords]
  devise_scope :customer do
    post '/customers/sign_up', to: 'registrations#create'
    post '/customers/sign_in', to: 'sessions#create'
    delete '/customers/sign_out', to: 'sessions#destroy'
  end

  root to: 'home#index'
end
