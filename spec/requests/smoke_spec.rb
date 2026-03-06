require "rails_helper"

RSpec.describe "Smoke request specs", type: :request do
  # Create minimal test data
  let!(:category) { OpenbillCategory.create!(name: "Test Category") }
  let!(:account) do
    OpenbillAccount.create!(
      key: "test-account-#{SecureRandom.hex(4)}",
      amount_currency: "RUB",
      category: category
    )
  end
  let!(:policy) do
    OpenbillPolicy.create!(
      name: "Test Policy",
      from_category: category,
      to_category: category
    )
  end

  after do
    OpenbillTransaction.delete_all
    OpenbillPolicy.delete_all
    OpenbillAccount.delete_all
    OpenbillCategory.delete_all
  end

  describe "GET /" do
    it "redirects to accounts" do
      get "/"
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /accounts" do
    it "responds successfully" do
      get "/accounts"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounts/:id" do
    it "responds successfully" do
      get "/accounts/#{account.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /transactions" do
    it "responds successfully" do
      get "/transactions"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /categories" do
    it "responds successfully" do
      get "/categories"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /policies" do
    it "responds successfully" do
      get "/policies"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /logs" do
    it "responds successfully" do
      get "/logs"
      expect(response).to have_http_status(:ok)
    end
  end
end

RSpec.describe "Smoke routing", type: :routing do
  it "routes core endpoints" do
    expect(get: "/").to route_to("welcome#index")
    expect(get: "/accounts").to route_to("accounts#index")
    expect(get: "/transactions").to route_to("transactions#index")
    expect(get: "/categories").to route_to("categories#index")
    expect(get: "/policies").to route_to("policies#index")
    expect(get: "/logs").to route_to("logs#index")
  end
end
