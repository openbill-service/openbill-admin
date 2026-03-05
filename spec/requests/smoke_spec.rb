require "rails_helper"

RSpec.describe "Smoke routes", type: :request do
  it "GET /" do
    get "/"
    expect(response).to have_http_status(:found)
  end

  it "GET /accounts" do
    get "/accounts"
    expect(response).to have_http_status(:ok)
  end

  it "GET /transactions" do
    get "/transactions"
    expect(response).to have_http_status(:ok)
  end

  it "GET /categories" do
    get "/categories"
    expect(response).to have_http_status(:ok)
  end

  it "GET /policies" do
    get "/policies"
    expect(response).to have_http_status(:ok)
  end

  it "GET /invoices" do
    get "/invoices"
    expect(response).to have_http_status(:ok)
  end

  it "GET /logs" do
    get "/logs"
    expect(response).to have_http_status(:ok)
  end
end
