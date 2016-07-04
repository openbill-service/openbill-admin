module ApplicationHelper
  def application_title
    "Openbill Admin #{AppVersion}"
  end

  def show_attribute(record, attribute_name)
    value = record.send attribute_name

    if attribute_name.to_s.end_with? '_at'
      I18n.l value, format: :short
    else
      value
    end

    content_tag :p, "#{attribute_name}: #{value}"
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
