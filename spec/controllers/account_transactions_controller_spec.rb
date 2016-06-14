require 'rails_helper'

describe AccountTransactionsController do
  let(:transaction_params) do
    {
      opposite_account_id: 1,
      amount_cents: 100,
      amount_currency: 'RUB',
      key: :key,
      details: :details
    }
  end

  before do
    account = double(id: 1, category_id: 1, amount_currency: 'RUB')
    transactions = double(insert: true)
    policies = double(where: [])
    allow(Openbill.service).to receive(:get_account_by_id).and_return account
    allow(Openbill.service).to receive(:transactions).and_return transactions
    allow(Openbill.service).to receive(:policies).and_return policies
  end

  it '#new' do
    get :new, account_id: 1, direction: :income
    assert_response :success
  end

  it '#create' do
    post :create, account_id: 1, direction: :income, account_transaction_form: transaction_params
    assert_response :redirect
  end
end
