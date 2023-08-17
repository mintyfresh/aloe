# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  delete '/auth/sign_out', as: :sign_out, to: 'auth#sign_out'

  get '/auth/discord', as: :discord_sign_in, to: nil
  match '/auth/discord/callback', to: 'auth#discord', via: %i[get post]

  resources :events do
    post '/registration', to: 'registrations#upsert', as: :registration
    delete '/registration', to: 'registrations#destroy'
  end
end
