# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  get  '/sign_in_with_discord', to: 'auth#sign_in_with_discord'
  post '/sign_out', to: 'auth#sign_out'

  get '/auth/discord', to: nil, as: :discord_oauth
  match '/auth/discord/callback', to: 'auth#discord', as: :discord_oauth_callback, via: %i[get post]

  resources :events do
    post '/registration', to: 'registrations#upsert', as: :registration
    delete '/registration', to: 'registrations#destroy'
  end

  namespace :api do
    namespace :webhooks do
      post '/discord', to: 'discord#callback'
    end
  end
end
