module MoneyHelper
  def humanized_amount(amount)
    return '-' unless amount.is_a? Money
    c = amount.to_f < 0 ? 'text-red-600' : 'text-emerald-600'
    c = 'text-gray-500' if amount.to_i == 0
    content_tag :span,
                humanized_money_with_symbol(amount),
                class: "whitespace-nowrap #{c}"
  end

  def money_symbol_from_string(value)
    Money::Currency.find(value).symbol
  end
end
