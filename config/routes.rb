# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # API
  namespace :api, defaults: { format: 'json' } do
    # Available since: 2019-11-02
    # Deprecated at: 2019-11-03
    # End of live: -
    namespace :v1 do
      resources :offers, only: %i[index show create update destroy]

      # JWT routes
      post 'auth' => 'auth#login'
      post 'auth/refresh' => 'auth#refresh'
    end

    # Available since: 2019-11-03
    # Deprecated at: -
    # End of live: -
    namespace :v2 do
      resources :offers, only: %i[index show create update destroy]

      # JWT routes
      post 'auth' => 'auth#login'
      post 'auth/refresh' => 'auth#refresh'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
