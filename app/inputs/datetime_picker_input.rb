class DatetimePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] = "datetime-local"
    input_html_options.delete(:readonly)
    set_value_html_option
    super(wrapper_options)
  end

  private

  def set_value_html_option
    return unless value.present?

    datetime = normalize_datetime(value)
    input_html_options[:value] ||= datetime&.strftime("%Y-%m-%dT%H:%M") || value.to_s
  end

  def value
    object.send(attribute_name) if object.respond_to?(attribute_name)
  end

  def normalize_datetime(raw_value)
    return raw_value.to_time if raw_value.respond_to?(:to_time)
    Time.zone.parse(raw_value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
