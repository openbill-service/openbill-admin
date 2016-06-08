require 'rails_helper'

describe PoliciesController do
  before do
    policies = double
    policy = double(id: 1, update: true, delete: true, to_hash: {})
    allow(policies).to receive(:eager).and_return(double(all: []))
    allow(policies).to receive(:first!).and_return(policy)
    allow(policies).to receive(:insert)
    allow(Openbill.service).to receive(:policies).and_return policies
    @request.env['HTTP_REFERER'] = 'http://new.example.com:3000/back'
  end

  it '#index' do
    get :index
    assert_response :success
  end

  it '#new' do
    get :new
    assert_response :success
  end

  it '#edit' do
    get :edit, id: 1
    assert_response :success
  end

  it '#create' do
    post :create, policy: { name: 'Created policy' }
    assert_response :redirect
  end

  it '#update' do
    patch :update, id: 1, policy: { name: 'Updated policy' }
    assert_response :redirect
  end

  it '#delete' do
    delete :destroy, id: 1
    assert_response :redirect
  end
end
