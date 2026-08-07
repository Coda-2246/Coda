Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root to: "pages#home"

  resources :entries do
    collection do
      post :extract
    end
  end

  resources :gigs

  resource :company, only: %i[show edit update]

  get "dashboard", to: "dashboard#show", as: :dashboard

  get "tax-adviser",
      to: "tax_adviser#show",
      as: :tax_adviser

  get "tax-adviser/widget", to: "tax_adviser#widget", as: :tax_adviser_widget

  post "tax-adviser/chats",
       to: "tax_adviser#create",
       as: :tax_adviser_chats

  get "tax-adviser/chats/:id",
      to: "tax_adviser#chat",
      as: :tax_adviser_chat

  post "tax-adviser/chats/:id/ask",
       to: "tax_adviser#ask",
       as: :ask_tax_adviser_chat

  get "up" => "rails/health#show",
      as: :rails_health_check
end
