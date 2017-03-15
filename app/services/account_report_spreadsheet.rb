class AccountReportSpreadsheet < Spreadsheet
  FIELDS = %w(key details url meta created_at updated_at amount).freeze

  def initialize(collection, periods)
    @periods = periods
    super collection, FIELDS + @periods
  end

  private

  def get_field(row, field)
    if @periods.include? field
      row.periods[field]
    else
      row.account.send field
    end
  end
end

