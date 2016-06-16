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

  def goods_collection
    Openbill.service.goods.where(group_id: nil).map do |good|
      [good.title, good.id]
    end
  end

  def good_units_collection
    Openbill.service.good_units.map do |good|
      [good.unit, good.unit]
    end
  end
end
