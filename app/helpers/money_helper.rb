module MoneyHelper
  def humanized_amount(amount)
    return '-' unless amount.is_a? Money
    c = amount.to_f < 0 ? 'text-danger' : 'text-success'
    c = 'text-muted' if amount.to_i == 0
    content_tag :span,
                humanized_money_with_symbol(amount),
                class: "text-nowrap #{c}"
  end

  def money_symbol_from_string(value)
    Money::Currency.find(value).symbol
  end
end
