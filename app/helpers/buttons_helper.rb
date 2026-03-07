module ButtonsHelper
  TW_BTN_VARIANTS = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    success: 'bg-emerald-600 text-white hover:bg-emerald-700',
    danger: 'bg-red-600 text-white hover:bg-red-700',
    warning: 'bg-amber-700 text-white hover:bg-amber-800',
    info: 'bg-sky-500 text-white hover:bg-sky-600',
    outline: 'border border-blue-600 text-blue-600 hover:bg-blue-50',
    default: 'bg-white border border-gray-300 text-gray-700 hover:bg-gray-50'
  }.freeze

  TW_BTN_SIZES = {
    xs: 'px-2 py-1 text-xs',
    sm: 'px-3 py-1.5 text-xs',
    md: 'px-4 py-2 text-sm'
  }.freeze

  TW_BTN_BASE = 'inline-flex items-center font-medium rounded-md transition disabled:opacity-50 disabled:cursor-not-allowed'.freeze

  def tw_button(label, variant: :primary, size: :md, **opts)
    variant_classes = TW_BTN_VARIANTS.fetch(variant)
    size_classes = TW_BTN_SIZES.fetch(size)
    extra = opts.delete(:class)
    css = [TW_BTN_BASE, variant_classes, size_classes, extra].compact.join(' ')
    content_tag(:button, label, **opts, class: css)
  end

  def tw_button_link(label, url, variant: :primary, size: :md, **opts)
    variant_classes = TW_BTN_VARIANTS.fetch(variant)
    size_classes = TW_BTN_SIZES.fetch(size)
    extra = opts.delete(:class)
    css = [TW_BTN_BASE, variant_classes, size_classes, extra].compact.join(' ')
    link_to(label, url, **opts, class: css)
  end

  def destroy_button(link)
    tw_button_link t('delete'), link, variant: :danger, size: :sm,
                   method: :delete, 'data-confirm' => 'Точно удалить?'
  end

  def edit_button(link)
    tw_button_link t('edit'), link, variant: :warning, size: :sm
  end

  def show_button(link)
    tw_button_link t('show'), link, variant: :info, size: :sm
  end
end
