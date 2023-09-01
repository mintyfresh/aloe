# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  get  '/sign_in_with_discord', to: 'auth#sign_in_with_discord'
  post '/sign_out', to: 'auth#sign_out'

  get '/auth/discord', to: nil, as: :discord_oauth
  match '/auth/discord/callback', to: 'auth#discord', as: :discord_oauth_callback, via: %i[get post]

  resources :api_keys, only: %i[index new create edit update] do
    post :rotate, on: :member
    post :revoke, on: :member
  end

  scope '/:organization_id' do
    get '/manage', to: 'organizations#manage', as: :manage_organization
    post '/install_token', to: 'organizations#generate_install_token', as: :generate_install_token

    resources :events do
      post '/registration', to: 'registrations#upsert', as: :registration
      delete '/registration', to: 'registrations#destroy'
    end
  end

  namespace :api do
    namespace :v1, constraints: { format: :json }, defaults: { format: :json } do
      resources :events, only: %i[index show create update destroy]
      resources :guilds, only: %i[index show]
      resources :users, only: %i[index show]
    end

    namespace :webhooks do
      post '/discord', to: 'discord#callback'
    end
  end
end
