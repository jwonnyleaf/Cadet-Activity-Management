# frozen_string_literal: true

Rails.application.routes.draw do
  get 'audit_activities/index'
  root 'home#index'
  get 'home/index', to: 'home#index', as: 'home'

  get '/users/:id', to: 'users#show', as: 'user'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :training_activities
  resources :user
  resources :audit_activities do
    member do
      post :approve
      post :improve
      post :reject
      post :resubmit
      post :cancel
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Mailer
  mount LetterOpenerWeb::Engine, at: '/letter_opener'

  # Defines the root path route ("/")
  # root "posts#index"
end
