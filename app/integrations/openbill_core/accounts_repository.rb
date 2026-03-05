module OpenbillCore
  class AccountsRepository
    def initialize(accounts: OpenbillAccount, opposite_lookup: OppositeAccountsByPolicy.new)
      @accounts = accounts
      @opposite_lookup = opposite_lookup
    end

    def suggestions(prefix:)
      q = prefix.to_s
      accounts.order(:key).where("key LIKE ?", "#{q}%")
    end

    def opposite_accounts_for(account:, direction:)
      opposite_lookup.call(account: account, direction: direction)
    end

    private

    attr_reader :accounts, :opposite_lookup
  end
end
