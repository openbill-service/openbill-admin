module TransactionDate
  module_function

  def parse(params)
    Date.new params['date(1i)'].to_i, params['date(2i)'].to_i, params['date(3i)'].to_i
  rescue => err
    Bugsnag.notify err
    nil
  end
end
