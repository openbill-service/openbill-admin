class Openbill::Category < ApplicationRecord
  def accounts_count
    # unknown
  end

  def <=> (other)
    id <=> other.id
  end

  def to_s
    name
  end
end
