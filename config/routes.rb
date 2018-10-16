Rails.application.routes.draw do
  get 'projects/index'

  resources :projects, only: %i[index create show update destroy] do
    patch :archive, on: :member

    resources :incidents, only: %i[index show update] do
      delete :clear, on: :member
    end

    resources :reports, only: %i[index create show] do
      get :preview, on: :collection
      post :send_mail, on: :member
    end

    resources :performances, only: [:index]

    resources :securities, only: [:index] do
      get :gemfile, on: :collection
      post :update_gemfile, on: :collection
      patch :delete_enddate, on: :member
      patch :update_enddate, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :github_security_webhooks do
        post :webhook, on: :collection
      end
    end
  end

  get 'query/exists', to: 'database_query#exists', as: 'query_exists'

  root 'projects#index'
end
