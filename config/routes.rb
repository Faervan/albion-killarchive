# frozen_string_literal: true

Rails.application.routes.draw do
  root 'main#index'

  resources :alliances, param: :name
  resources :guilds, param: :name
  resources :players, param: :name
  # resources :main_hand_types
  resources :awakened_weapons
  resources :builds

  get '/main_hand_types', to: 'main_hand_types#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
