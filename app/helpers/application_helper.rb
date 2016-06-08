module ApplicationHelper
  def application_title
    "Openbill Admin #{AppVersion}"
  end

  def humanized_meta(meta)
    content_tag :code, meta
  end

  def categories_collection
    Openbill.service.categories.all.map do |category|
      [category.name, category.id]
    end
  end

  def currencies_collection
    [:rub, :usd, :eur].map do |currency|
      [currency.upcase, currency.upcase]
    end
  end
end
