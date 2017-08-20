Rails.application.routes.draw do
  # Route config for ActiveAdmin
  ActiveAdmin.routes(self)

  devise_for :users, skip: [:sessions, :passwords, :registrations, :confirmations, :invitations]

  devise_scope :user do
    post    :forgot_password,   to: "passwords#create",     as: :user_password
    get     :forgot_password,   to: "passwords#new",        as: :new_user_password
    get     :reset_password,    to: "passwords#edit",       as: :edit_user_password
    put     :reset_password,    to: "passwords#update",     as: :reset_user_password

    delete  :logout,            to: "sessions#destroy",     as: :destroy_user_session
    post    :login,             to: "sessions#create",      as: :user_session
    get     :login,             to: "sessions#new",         as: :new_user_session

    post    :signup,            to: "registrations#create",   as: :user_registration
    get     :signup,            to: "registrations#new",      as: :new_user_registration
    get     :profile,           to: "registrations#edit",     as: :edit_user_registration
    put     :profile,           to: "registrations#update",   as: :update_user_registration
    post    :regenerate_api_key,to: "registrations#regenerate_api_key", as: :regenerate_api_key

    post    :activate,          to: "confirmations#create", as: :user_confirmation
    get     :activate,          to: "confirmations#new",    as: :new_user_confirmation
    get     :confirmation,      to: "confirmations#show"

    get     :accept_invitation, to: "invitations#edit",     as: :user_invitation
    put     :accept_invitation, to: "invitations#update"
  end

  resources :users, path: :members do 
    collection do
      post :approve,        action: :approve_user
      post :disapprove,     action: :disapprove_user
      post :grant_admin,    action: :grant_admin
      post :revoke_admin,   action: :revoke_admin
    end
  end
  resources :activities
  resources :organizations

  resources :countries do
    resources :sites
  end


  resources :sites do
    collection do
      post :add_role
      post :remove_role
    end
  end

  resources :languages do
    resources :articles
  end

  resources :categories

  resources :articles do
    member do
      post :publish
      post :unpublish
    end
  end

  ## API routes
  namespace :api do
    resources :users
    resources :articles
    resources :countries
    resources :categories
    resources :languages
    resources :sites 
 end

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end
