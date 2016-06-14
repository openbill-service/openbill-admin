require 'rails_helper'

describe LogsController do
  before do
    webhook_logs = double
    allow(webhook_logs).to receive(:paginate).and_return webhook_logs
    allow(webhook_logs).to receive(:reverse_order).and_return webhook_logs
    allow(Openbill.service).to receive(:webhook_logs).and_return webhook_logs
  end

  it '#index' do
    get :index
    assert_response :success
  end
end
