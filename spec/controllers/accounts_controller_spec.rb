require 'rails_helper'

describe AccountsController do
  before do
    accounts = double(insert: true, update: true)
    account = double(id: 1, key: :key, update: true, delete: true, to_hash: {})
    account_transactions = double(reverse_order: double(paginate: accounts))

    allow(accounts).to receive(:where).and_return(accounts)
    allow(accounts).to receive(:paginate).and_return(accounts)
    allow(Openbill.service).to receive(:accounts).and_return accounts
    allow(Openbill.service).to receive(:get_account).and_return account
    allow(Openbill.service).to receive(:account_transactions).and_return account_transactions
    @request.env['HTTP_REFERER'] = 'http://new.example.com:3000/back'
  end

  it '#index' do
    get :index
    assert_response :success
  end

  it '#show' do
    get :show, id: 1
    assert_response :success
  end

  it '#edit' do
    get :edit, id: 1
    assert_response :success
  end

  it '#create' do
    post :create, account: { details: 'details' }
    assert_response :redirect
  end

  it '#update' do
    patch :update, id: 1, account: { key: 1, category_id: 1, details: 'details' }
    assert_response :redirect
  end
end
