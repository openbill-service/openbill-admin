class AccountsController < ApplicationController
  def index
    render locals: {
      accounts: accounts,
      categories: categories
    }
  end

  def show
  end

  private

  def accounts
    Openbill.service.accounts.paginate page, per_page
  end

  def categories
    Openbill.service.categories
  end
end
