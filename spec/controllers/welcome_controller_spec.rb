require 'rails_helper'

describe WelcomeController do
  it '#index' do
    get :index
    assert_response :redirect
  end
end
