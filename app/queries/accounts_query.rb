class AccountsQuery
  include Virtus.model

  attribute :filter, AccountsFilter

  def call
    scope = philtre.apply basic_scope
    scope = scope.where(openbill_accounts__id: filter.id) if filter.id.present?
    scope = scope.where(openbill_accounts__category_id: filter.category_id) if filter.category_id.present?
    scope.paginate filter.page, filter.per_page
  end

  private

  def basic_scope
    if filter.date.present?
      Openbill.service.accounts_for_date filter.date
    else
      Openbill.service.accounts
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
