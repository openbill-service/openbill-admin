class AddOpenbillPeriodAmountFunction < ActiveRecord::Migration
  SQL_DIR = './db/sql/'

  def change
    migrate_sql_file 'period_amount.sql'
  end

  private

  def migrate_sql_file(file)
    say_with_time "Migrate with #{file}" do
      execute File.read SQL_DIR + file
    end
  end
end
