class AccountsQuery
  include Virtus.model

  attribute :filter, AccountsFilter

  def call
    scope = philtre.apply basic_scope
    scope = scope.where(openbill_accounts__id: filter.id) if filter.id.present?
    scope = scope.where(openbill_accounts__category_id: filter.category_id) if filter.category_id.present?
    scope.page(filter.page).per filter.per_page
  end

  private

  def accounts_at_date(date)
    # TODO
    raise 'implement'
    #dataset
    #.select_all(:openbill_accounts)
    #.left_join(
      #Sequel.as(:openbill_transactions, :t1),
      #[
        #Sequel.lit('t1.date <= ?', date),
        #Sequel.or(
          #t1__from_account_id: :openbill_accounts__id,
          #t1__to_account_id: :openbill_accounts__id
        #)
      #]
    #)
    #.select_append(
      #Sequel.as(
        #Sequel.lit('SUM(COALESCE((CASE openbill_accounts.id WHEN t1.from_account_id THEN -t1.amount_cents ELSE t1.amount_cents END)::bigint, 0))'),
        #:date_amount_cents
      #)
    #)
    #.group(:openbill_accounts__id)
  end

  def basic_scope
    if filter.date.present?
      accounts_at_date filter.date
    else
      OpenbillAccount.all
    end
  end

  def philtre
    Philtre.new filter.philtre do
      def date(date)
        true
      end

      def amount_cents_lte(amount)
        Sequel.lit('openbill_accounts.amount_cents <= ?', amount.to_money.cents)
      end

      def amount_cents_gte(amount)
        Sequel.lit('openbill_accounts.amount_cents >= ?', amount.to_money.cents)
      end

      def details_like(text)
        like(:openbill_accounts__details, text)
      end

      def key_like(text)
        like(:openbill_accounts__key, text)
      end
    end
  end
end
