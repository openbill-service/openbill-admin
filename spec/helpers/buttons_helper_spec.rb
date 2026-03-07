require "rails_helper"

RSpec.describe ButtonsHelper, type: :helper do
  describe "#tw_button" do
    it "raises KeyError for unknown variant" do
      expect { helper.tw_button("Test", variant: :nonexistent) }.to raise_error(KeyError)
    end

    it "raises KeyError for unknown size" do
      expect { helper.tw_button("Test", size: :nonexistent) }.to raise_error(KeyError)
    end

    it "renders with valid variant" do
      result = helper.tw_button("Test", variant: :danger)
      expect(result).to include("bg-red-600")
    end
  end
end
