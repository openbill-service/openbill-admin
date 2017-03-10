class LogsController < ApplicationController
  def index
    render locals: {
      logs: logs,
      ransack: ransack
    }
  end

  private

  def ransack
    OpenbillWebhookLog.ransack params[:q]
  end

  def logs
    all_logs.page(page).per(per_page)
  end

  def all_logs
    ransack.result.ordered
  end
end
