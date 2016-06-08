require 'rails_helper'

describe TransactionsController do
  it '#index' do
    get :index
    assert_response :success
  end
end
