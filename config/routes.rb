Rails.application.routes.draw do

  root to: "registrations#new"

  devise_for :users

  resources :registrations, only: [:show, :create, :edit, :update, :destroy] do
    resources :clients, only: [:create]
    member do
      get 'submit'
    end
  end

  get 'page-perso', to: 'pages#page_perso', as: :page_perso
  get 'download', to: 'pages#download', as: :download

  get "up" => "rails/health#show", as: :rails_health_check

end

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
# Can be used by load balancers and uptime monitors to verify that the app is live.
