class TimePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] = "time"
    input_html_options.delete(:readonly)
    set_value_html_option
    super(wrapper_options)
  end

  private

  def set_value_html_option
    return unless value.present?

    time = normalize_time(value)
    input_html_options[:value] ||= time&.strftime("%H:%M") || value.to_s
  end

  def value
    object.send(attribute_name) if object.respond_to?(attribute_name)
  end

  def normalize_time(raw_value)
    return raw_value.to_time if raw_value.respond_to?(:to_time)
    Time.zone.parse(raw_value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
