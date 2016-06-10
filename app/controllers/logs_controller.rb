class LogsController < ApplicationController
  helper_method :filter

  def index
    render locals: {
      logs: logs, db_error: @db_error
    }
  end

  private

  def logs
    filter.apply(Openbill.service.webhook_logs.reverse_order(:created_at)).paginate page, per_page
  rescue Sequel::DatabaseError => err
    @db_error = err.message
    Bugsnag.notify err
    []
  end
end
