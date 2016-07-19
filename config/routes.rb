Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, except: [:destroy] do
    resources :transactions, controller: 'account_transactions', only: [:index, :new, :create, :show]
  end

  # All transactions
  resources :transactions do
    member do
      post :notify
    end
  end
  resources :categories
  resources :policies
  resources :logs, only: [:index]
  resources :goods
  resources :goods_availabilities
end
