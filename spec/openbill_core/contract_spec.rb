require "rails_helper"

RSpec.describe OpenbillCore::Contract do
  it "validates current openbill-core DB contract" do
    expect { described_class.new.verify! }.not_to raise_error
  end
end
