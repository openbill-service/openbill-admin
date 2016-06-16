require 'rails_helper'

RSpec.describe GoodsController, type: :controller do
  before do
    goods = double
    good = double(id: 1, update: true, delete: true, to_hash: {})
    allow(goods).to receive(:eager).and_return(double(all: []))
    allow(goods).to receive(:first!).and_return(good)
    allow(goods).to receive(:insert)
    allow(Openbill.service).to receive(:goods).and_return goods
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
    post :create, good: { title: 'Created good', unit: 'count' }
    assert_response :redirect
  end

  it '#update' do
    patch :update, id: 1, good: { title: 'Updated good', unit: 'count' }
    assert_response :redirect
  end

  it '#destroy' do
    delete :destroy, id: 1
    assert_response :redirect
  end
end
