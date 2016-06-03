Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, only: [:index, :show] do
    resources :transactions, controller: 'account_transactions', only: [:index, :new, :create, :show]
  end

  # All transactions
  resources :transactions, only: [:index]
  resources :categories
end
