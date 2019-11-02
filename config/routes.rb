# frozen_string_literal: true

Rails.application.routes.draw do
  # API
  namespace :api, defaults: { format: 'json' } do
    # Available since: 2019-11-02
    # Deprecated at: -
    # End of live: -
    namespace :v1 do
      resources :offers, only: %i[index show create update destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
