# frozen_string_literal: true

# Tailwind CSS wrappers for SimpleForm.
# Loaded after simple_form.rb (alphabetical order).
SimpleForm.setup do |config|
  config.wrappers :tailwind, class: 'mb-4' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500', error_class: 'border-red-500 focus:ring-red-500'
    b.use :hint, wrap_with: { tag: :p, class: 'text-gray-500 text-xs mt-1' }
    b.use :error, wrap_with: { tag: :p, class: 'text-red-600 text-xs mt-1' }
  end

  config.wrappers :tailwind_boolean, class: 'mb-4 flex items-center gap-2' do |b|
    b.use :html5
    b.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500'
    b.use :label, class: 'text-sm text-gray-700'
  end

  config.wrappers :tailwind_select, class: 'mb-4' do |b|
    b.use :html5
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 bg-white'
    b.use :hint, wrap_with: { tag: :p, class: 'text-gray-500 text-xs mt-1' }
    b.use :error, wrap_with: { tag: :p, class: 'text-red-600 text-xs mt-1' }
  end

  config.default_wrapper = :tailwind
  config.button_class = 'inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition'
  config.boolean_label_class = 'text-sm text-gray-700'
end
