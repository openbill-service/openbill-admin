Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, only: [:index, :show, :edit, :update] do
    resources :transactions, controller: 'account_transactions', only: [:index, :new, :create, :show]
  end

  # All transactions
  resources :transactions, only: [:index] do
    member do
      post :notify
    end
  end
  resources :categories
  resources :policies
end
