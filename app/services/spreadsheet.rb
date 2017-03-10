require 'csv'

class Spreadsheet
  attr_reader :collection, :fields

  def initialize(collection, fields)
    @collection = collection
    @fields = fields
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << fields
      collection.find_each do |t|
        csv << row(t)
      end
    end
  end

  private

  def row(t)
    fields.map{ |f| get_field(t, f) }
  end

  def get_field(t, f)
    t.send f
  end
end
