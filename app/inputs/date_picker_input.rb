class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    set_html_options
    set_value_html_option
    super(wrapper_options)
  end

  def input_html_classes
    super
  end

  private

  def set_html_options
    input_html_options[:type] = 'date'
    input_html_options.delete(:readonly)
    input_html_options.delete(:data)
  end

  def set_value_html_option
    return unless value.present?
    date = normalize_date(value)
    input_html_options[:value] ||= date&.strftime("%Y-%m-%d") || value.to_s
  end

  def value
    object.send(attribute_name) if object.respond_to? attribute_name
  end

  def normalize_date(raw_value)
    return raw_value.to_date if raw_value.respond_to?(:to_date)
    Date.parse(raw_value.to_s)
  rescue ArgumentError, TypeError
    nil
  end

end
