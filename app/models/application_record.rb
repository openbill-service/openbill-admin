class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix='openbill_'

  def self.ransackable_attributes(_auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(_auth_object = nil)
    reflections.keys
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.gsub('Openbill', ''))
  end

  def to_s
    name
  end
end
