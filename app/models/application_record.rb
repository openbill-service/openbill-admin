class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.model_name
    ActiveModel::Name.new(self, nil, name.gsub('Openbill', ''))
  end

  def to_s
    name
  end
end
