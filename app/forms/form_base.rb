class FormBase
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def persisted?
    false
  end

  def to_key
    nil
  end

  private

  def nilify_blanks(options = {})
    keys = options[:only] || attribute_names
    keys.each do |key|
      key_name = key.to_s
      current = public_send(key_name)
      public_send("#{key_name}=", nil) if current.blank?
    end
  end

  def parse_json_object(value, field_name:)
    return {} if value.blank?
    return value if value.is_a?(Hash)

    parsed = JSON.parse(value.to_s)
    return parsed if parsed.is_a?(Hash)

    raise JSON::ParserError, "#{field_name} must be a JSON object"
  end
end
