Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, except: [:destroy] do
    collection do
      get :suggestions
      get :at_date
    end
    member do
      get :months
    end
    resources :transactions, controller: 'account_transactions', only: [:index, :new, :create, :show]
    resources :reports, controller: 'account_reports', only: [:index, :show]
    member do
      get :webhook_logs
    end
  end

  # All transactions
  resources :transactions do
    collection do
      get :pending_webhooks
    end
    member do
      post :notify
    end
  end
  resources :categories
  resources :invoices
  resources :policies
  resources :logs, only: [:index]
end
