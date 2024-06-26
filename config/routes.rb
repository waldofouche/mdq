# frozen_string_literal: true

Rails.application.routes.draw do
  resources :entities, only: [:index]
  get 'mdq/entities/:entity_id', to: 'mdq#index', constraints: { entity_id: /.*/ }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
end
