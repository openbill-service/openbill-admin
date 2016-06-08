require 'rails_helper'

describe AccountsController do
  before do
    accounts = double(paginate: nil, per_page: nil)
    account = double(id: 1, update: true, delete: true, to_hash: {})
    account_transactions = double(reverse_order: [])

    allow(accounts).to receive(:insert)
    allow(accounts).to receive(:where).and_return(accounts)
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

  it '#update' do
    patch :update, id: 1, account: { details: 'details' }
    assert_response :redirect
  end
end
