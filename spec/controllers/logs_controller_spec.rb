require 'rails_helper'

describe LogsController do
  it '#index' do
    get :index
    assert_response :success
  end
end
