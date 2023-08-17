# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  delete '/auth/sign_out', as: :sign_out, to: 'auth#sign_out'

  # get '/auth/discord', as: :auth_discord, to: nil
  match '/auth/discord/callback', to: 'auth#discord', via: %i[get post]

  resources :events
end
