require "rails_helper"

RSpec.describe "Smoke routes", type: :routing do
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
