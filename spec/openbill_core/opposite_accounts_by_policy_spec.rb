require "rails_helper"
require "securerandom"

RSpec.describe OpenbillCore::OppositeAccountsByPolicy do
  let(:lookup) { described_class.new }

  around do |example|
    ApplicationRecord.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  def uniq(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def create_category(prefix)
    OpenbillCategory.create!(name: uniq(prefix))
  end

  def create_account(category, prefix)
    OpenbillAccount.create!(
      category_id: category.id,
      key: uniq(prefix),
      amount_currency: "USD"
    )
  end

  def create_policy(attrs)
    OpenbillPolicy.create!({ name: uniq("policy") }.merge(attrs))
  end

  it "returns opposite accounts for income direction based on policy" do
    destination_category = create_category("dest-category")
    source_category = create_category("source-category")

    destination = create_account(destination_category, "destination")
    allowed_by_account = create_account(source_category, "allowed-account")
    allowed_by_category = create_account(source_category, "allowed-category")
    blocked = create_account(create_category("blocked-category"), "blocked")

    create_policy(to_account_id: destination.id, from_account_id: allowed_by_account.id)
    create_policy(to_account_id: destination.id, from_category_id: source_category.id)

    result = lookup.call(account: destination, direction: AccountTransactionForm::INCOME_DIRECTION)

    expect(result.map(&:id)).to include(allowed_by_account.id, allowed_by_category.id)
    expect(result.map(&:id)).not_to include(blocked.id)
  end

  it "returns opposite accounts for outcome direction based on policy" do
    source_category = create_category("source-category")
    destination_category = create_category("dest-category")

    source = create_account(source_category, "source")
    allowed_by_account = create_account(destination_category, "allowed-account")
    allowed_by_category = create_account(destination_category, "allowed-category")
    blocked = create_account(create_category("blocked-category"), "blocked")

    create_policy(from_account_id: source.id, to_account_id: allowed_by_account.id)
    create_policy(from_account_id: source.id, to_category_id: destination_category.id)

    result = lookup.call(account: source, direction: AccountTransactionForm::OUTCOME_DIRECTION)

    expect(result.map(&:id)).to include(allowed_by_account.id, allowed_by_category.id)
    expect(result.map(&:id)).not_to include(blocked.id)
  end

  it "raises error for unknown direction" do
    category = create_category("category")
    account = create_account(category, "account")

    expect do
      lookup.call(account: account, direction: "unsupported")
    end.to raise_error(ArgumentError, /Unknown direction/)
  end
end
