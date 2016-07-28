class LogsController < ApplicationController
  helper_method :filter

  def index
    render locals: {
      logs: logs, db_error: @db_error
    }
  end

  private

  def webhooks_filter
    WebhooksFilter.new(
      transaction_ids: [params[:transaction_id]]
    )
  end

  def logs
    query = WebhooksQuery.new(filter: webhooks_filter).call
    filter.apply(query).paginate page, per_page
  rescue Sequel::DatabaseError => err
    @db_error = err.message
    Bugsnag.notify err
    []
  end
end
