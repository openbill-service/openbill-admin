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
  end

  # All transactions
  resources :transactions
  resources :categories
  resources :policies
end
