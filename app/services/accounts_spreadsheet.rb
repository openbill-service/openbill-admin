class AccountsSpreadsheet < Spreadsheet
  FIELDS = %w(key details url meta created_at updated_at amount).freeze

  def initialize(collection, periods)
    @periods = periods
    super collection, FIELDS + @periods
  end

  private

  def get_field(row, field)
    if @periods.include? field
      row.amount_by_period field
    else
      super row, field
    end
  end
end
