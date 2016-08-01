Rails.application.routes.draw do
  root 'welcome#index'

  resources :accounts, except: [:destroy] do
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
  resources :policies
  resources :logs, only: [:index]
  resources :goods
  resources :goods_availabilities
end
