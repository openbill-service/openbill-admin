module ApplicationHelper
  FLASH_COLORS = {
    'error' => 'bg-red-50 border-red-200 text-red-800',
    'alert-danger' => 'bg-red-50 border-red-200 text-red-800',
    'alert' => 'bg-red-50 border-red-200 text-red-800',
    'warning' => 'bg-amber-50 border-amber-200 text-amber-800',
    'alert-warning' => 'bg-amber-50 border-amber-200 text-amber-800',
    'notice' => 'bg-blue-50 border-blue-200 text-blue-800',
    'alert-info' => 'bg-blue-50 border-blue-200 text-blue-800',
    'success' => 'bg-emerald-50 border-emerald-200 text-emerald-800',
    'alert-success' => 'bg-emerald-50 border-emerald-200 text-emerald-800'
  }.freeze

  FLASH_DEFAULT_COLOR = 'bg-blue-50 border-blue-200 text-blue-800'.freeze


  def app_title
    "Openbill Admin #{AppVersion}"
  end

  def export_csv_link
    link_to 'Export to CSV', url_for(request.query_parameters.merge format: :csv),
            class: 'inline-flex items-center font-medium rounded-md transition px-3 py-1.5 text-xs bg-white border border-gray-300 text-gray-700 hover:bg-gray-50',
            target: '_blank'
  end

  def back_link(url = nil)
    link_to "&larr; #{t('helpers.back')}".html_safe, url || root_path,
            class: 'text-sm text-blue-600 hover:text-blue-800 hover:underline'
  end

  def back_url
    params[:back_url] || @back_url || request.referer.presence || root_url # rubocop:disable Rails/HelperInstanceVariable
  end

  def current_url
    request.url
  end

  def spinner
    content_tag :svg, class: "animate-spin h-5 w-5 text-blue-600", xmlns: 'http://www.w3.org/2000/svg',
                      fill: 'none', viewBox: '0 0 24 24', role: 'status' do
      safe_join([
        content_tag(:circle, '', cx: '12', cy: '12', r: '10', stroke: 'currentColor',
                    'stroke-width': '4', class: 'opacity-25'),
        content_tag(:path, '', fill: 'currentColor', class: 'opacity-75',
                    d: 'M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z')
      ])
    end
  end

  def full_error_messages(form)
    return if form.object.errors.empty?

    content_tag :div, class: 'bg-red-50 border border-red-200 text-red-800 rounded-md p-4', role: 'alert' do
      form.object.errors.full_messages.to_sentence
    end
  end

  def humanized_period(period)

    if period.month?
      l period.first, format: :month_and_year
    else
      if period.first.present?
        first = l period.first, format: :long
        last = l period.last, format: :long
        "#{content_tag(:span, first, class: 'whitespace-nowrap')} - #{content_tag(:span, last, class: 'whitespace-nowrap')}".html_safe
      else
        last = l period.last, format: :long
        "до #{content_tag(:span, last, class: 'whitespace-nowrap')}".html_safe
      end
    end
  end

  def humanized_date(date)
    return '-' unless date.present?
    content_tag :div, class: 'whitespace-nowrap' do
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
    content_tag :code, meta.to_json
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
