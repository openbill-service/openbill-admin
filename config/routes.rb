Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, except: [:destroy] do
    resources :transactions, controller: 'account_transactions', only: [:index, :new, :create, :show]
  end

  # All transactions
  resources :transactions, only: [:index, :new, :create] do
    member do
      post :notify
    end
  end
  resources :categories
  resources :policies
  resources :logs, only: [:index]
end
