module TransactionDate
  module_function

  def parse(params)
    return nil if params.nil? || !params.key?('date')
    Date.parse params['date']
  end
end
