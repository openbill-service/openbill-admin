module ReportHelper
  def report_column_title(report, column)
    if column == :total
      t :total
    else
      link_to l(column), account_transactions_path(account.id, q: { month: column })
    end
  end
end
