module ApplicationHelper
  def application_title
    "Openbill Admin #{AppVersion}"
  end

  def webhook_presents?
    OpenbillWebhookLog.table_exists?
  end

  def humanized_date(date)
    return '-' unless date.present?
    content_tag :div, class: 'text-nowrap' do
      I18n.l date, format: :long
    end
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
    return unless meta.present?
    content_tag :code, meta
  end

  def categories_collection
    OpenbillCategory.all.map do |category|
      [category.name, category.id]
    end
  end

  def currencies_collection
    [:rub, :usd, :eur].map do |currency|
      [currency.upcase, currency.upcase]
    end
  end
end
