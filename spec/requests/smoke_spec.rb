require "rails_helper"

RSpec.describe "Smoke request specs", type: :request do
  let!(:category) { OpenbillCategory.create!(name: "Test Category") }
  let!(:other_category) { OpenbillCategory.create!(name: "Other Category") }
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
      to_category: other_category
    )
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

    it "returns 404 for nonexistent account" do
      get "/accounts/00000000-0000-0000-0000-000000000000"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /accounts/:id/months" do
    it "responds successfully" do
      get "/accounts/#{account.id}/months"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounts/suggestions" do
    it "responds successfully" do
      get "/accounts/suggestions", params: { q: "test" }
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

  describe "GET /categories/:id" do
    it "responds with redirect" do
      get "/categories/#{category.id}"
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /accounts/:account_id/reports" do
    it "responds successfully" do
      get "/accounts/#{account.id}/reports"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /transactions/:id" do
    let!(:other_account) do
      OpenbillAccount.create!(
        key: "other-account-#{SecureRandom.hex(4)}",
        amount_currency: "RUB",
        category: other_category
      )
    end
    let!(:transaction) do
      OpenbillTransaction.create!(
        from_account: account,
        to_account: other_account,
        amount_cents: 1000,
        amount_currency: "RUB",
        key: "test-tx-#{SecureRandom.hex(4)}",
        details: "Test transaction",
        username: "test"
      )
    end

    it "responds successfully" do
      get "/transactions/#{transaction.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /policies" do
    it "responds successfully" do
      get "/policies"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /policies" do
    it "creates a policy with valid params" do
      post "/policies", params: {
        policy: {
          name: "New Policy",
          from_category_id: category.id,
          to_category_id: other_category.id
        }
      }
      expect(response).to have_http_status(:found)
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
  end

  it "does not route removed resources" do
    expect(get: "/invoices").not_to be_routable
    expect(get: "/logs").not_to be_routable
  end
end
