module TransactionDate
  module_function

  def parse(params)
    Date.parse params['date']
  rescue => err
    Bugsnag.notify err
    nil
  end
end
