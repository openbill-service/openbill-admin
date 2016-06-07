class TransactionsController < ApplicationController
  def index
    render locals: {
      transactions: transactions
    }
  end

  def notify
    flash[:success] = "Transaction #{transaction.id} is notified"
    Openbill.service.notify_transaction transaction
    redirect_to :back
  end

  private

  def transaction
    Openbill.service.get_transaction params[:id]
  end

  def transactions
    filter.apply(Openbill.service.transactions.reverse_order(:created_at)).paginate page, per_page
  end
end
