class TransactionsController < ApplicationController
  helper_method :filter

  def index
    render locals: {
      transactions: transactions.eager(*transaction_eager).all,
      transactions_count: transactions.pagination_record_count
    }
  end

  def new
    render locals: { transaction: TransactionForm.new }
  end

  def create
    transaction_form = TransactionForm.new permitted_params

    if transaction_form.valid?
      transactions.insert transaction_form.to_hash
      redirect_to transactions_path
    else
      render :new, locals: { transaction: transaction_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { transaction: transaction_form }
  end

  def notify
    flash[:success] = "Transaction #{transaction.id} is notified"
    Openbill.service.notify_transaction transaction
    redirect_to :back
  end

  private

  def transaction_eager
    if Features.has_goods?
      [:good, :from_account, :to_account]
    else
      [:from_account, :to_account]
    end
  end

  def transaction
    Openbill.service.get_transaction params[:id]
  end

  def transactions
    filter.apply(Openbill.service.transactions.reverse_order(:created_at)).paginate page, per_page
  end

  def permitted_params
    params.require(:transaction).permit(:from_account_id, :to_account_id,
                                        :good_id, :good_value, :good_unit,
                                        :amount_cents, :amount_currency, :key, :details, :meta)
  end
end
