require "rails_helper"

RSpec.describe "Smoke routes", type: :request do
  before do
    OpenbillTransaction.delete_all
    OpenbillInvoice.delete_all
    OpenbillPolicy.delete_all
    OpenbillAccount.delete_all
    OpenbillCategory.delete_all
  end

  it "responds on core pages without server errors" do
    get "/"
    expect(response).to have_http_status(:found)

    %w[/transactions /categories /policies /invoices /logs].each do |path|
      get path
      expect(response).to have_http_status(:ok), "Expected #{path} to return 200, got #{response.status}. Body: #{response.body.to_s[0, 500]}"
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
    expect(get: "/invoices").to route_to("invoices#index")
    expect(get: "/logs").to route_to("logs#index")
  end
end
