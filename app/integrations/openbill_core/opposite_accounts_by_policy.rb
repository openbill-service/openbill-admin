module OpenbillCore
  class OppositeAccountsByPolicy
    def initialize(accounts: OpenbillAccount, policies: OpenbillPolicy)
      @accounts = accounts
      @policies = policies
    end

    def call(account:, direction:)
      case direction
      when AccountTransactionForm::INCOME_DIRECTION
        resolve(
          policy_scope: income_policies(account),
          account_id_column: :from_account_id,
          category_id_column: :from_category_id
        )
      when AccountTransactionForm::OUTCOME_DIRECTION
        resolve(
          policy_scope: outcome_policies(account),
          account_id_column: :to_account_id,
          category_id_column: :to_category_id
        )
      else
        raise ArgumentError, "Unknown direction #{direction.inspect}"
      end
    end

    private

    attr_reader :accounts, :policies

    def income_policies(account)
      policies.where(
        "(to_account_id = :account_id OR to_account_id IS NULL) AND (to_category_id = :category_id OR to_category_id IS NULL)",
        account_id: account.id,
        category_id: account.category_id
      )
    end

    def outcome_policies(account)
      policies.where(
        "(from_account_id = :account_id OR from_account_id IS NULL) AND (from_category_id = :category_id OR from_category_id IS NULL)",
        account_id: account.id,
        category_id: account.category_id
      )
    end

    def resolve(policy_scope:, account_id_column:, category_id_column:)
      arel = accounts.arel_table

      predicates = policy_scope.each_with_object([]) do |policy, result|
        predicate = nil

        account_id = policy.public_send(account_id_column)
        category_id = policy.public_send(category_id_column)

        if account_id.present?
          predicate = arel[:id].eq(account_id)
        end

        if category_id.present?
          category_predicate = arel[:category_id].eq(category_id)
          predicate = predicate ? predicate.and(category_predicate) : category_predicate
        end

        result << predicate if predicate
      end

      return accounts.none if predicates.empty?

      query = predicates.reduce { |left, right| left.or(right) }
      accounts.where(query).distinct.order(:key)
    end
  end
end
