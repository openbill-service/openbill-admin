require 'rails_helper'

describe WelcomeController do
  it '#index' do
    get :index
    assert_response :success
  end
end
