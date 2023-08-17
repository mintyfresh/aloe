# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  # get '/auth/discord', as: :auth_discord, to: nil
  match '/auth/discord/callback', to: 'auth#discord', via: %i[get post]

  resources :events
end
