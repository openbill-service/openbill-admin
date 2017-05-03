module ApplicationHelper
  def full_error_messages(f)
    f.object.errors.full_messages.to_sentence
  end

  def application_title
    "Openbill Admin #{AppVersion}"
  end

  def export_csv_link
    link_to 'Export to CSV', url_for(params.merge format: :csv), class: 'btn btn-sm btn-default', target: '_blank'
  end

  def humanized_period(period)

    if period.month?
      l period.first, format: :month_and_year
    else
      if period.first.present?
        first = l period.first, format: :long
        last = l period.last, format: :long
        "#{content_tag(:span, first, class: 'text-nowrap')} - #{content_tag(:span, last, class: 'text-nowrap')}".html_safe
      else
        last = l period.last, format: :long
        "до #{content_tag(:span, last, class: 'text-nowrap')}".html_safe
      end
    end
  end

  def webhook_presents?
    # TODO
    # OpenbillWebhookLog.table_exists?
    false
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
