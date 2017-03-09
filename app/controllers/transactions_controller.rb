class TransactionsController < ApplicationController
  helper_method :filter

  def index
    render locals: {
      transactions: transactions.includes(:to_account, :from_account).page(page).per(per_page),
      transactions_count: transactions.count,
      ransack: ransack
    }
  end

  def pending_webhooks
    render locals: {
      transactions: pending_webhooks_transactions.includes(:to_account, :from_account, :last_webhook_log).page(page).per(per_page),
      transactions_count: transactions.count
    }
  end

  def new
    if reverse_transaction.present?
      transaction.amount_cents = reverse_transaction.amount.to_f
      transaction.amount_currency = reverse_transaction.amount_currency
      transaction.from_account_id = reverse_transaction.to_account_id
      transaction.to_account_id = reverse_transaction.from_account_id
      transaction.key = reverse_transaction.key + '-reverse'
      transaction.date = reverse_transaction.date
      transaction.details = "Reverse of #{reverse_transaction.details}"
    end
    render locals: { transaction: OpenbillTransaction.new(permitted_params) }
  end

  def edit
    transaction.update permitted_params
    render :new, locals: { transaction: transaction }
  end

  def create
    transaction = OpenbillTransaction.new permitted_params
    if transaction.save
      redirect_to transactions_path
    else
      render :new, locals: { transaction: transaction }
    end
  end

  def update
    transaction.update permitted_params
    if transaction.valid?
      redirect_to transactions_path
    else
      render :new, locals: { transaction: transaction }
    end
  end

  def notify
    flash[:success] = "Transaction #{transaction.id} is notified"
    transaction.notify!
    redirect_to :back
  end

  def show
    render locals: { transaction: transaction }
  end

  def destroy
    transaction.destroy!
    redirect_to transactions_path
  rescue => err
    redirect_to transactions_path, flash: { error: err.message }
  end

  def export
    content = TransactionsSpreadsheet.new(transactions).to_csv
    send_data(
        content,
        disposition: 'attachment; filename=transactions.csv',
        type: 'text/csv'
    )
  end

  private

  def transaction
    @transaction ||= Transaction.find params[:id]
  end

  def date
    return unless params.key?(:transaction)
    TransactionDate.parse permitted_params
  end

  def reverse_transaction
    return nil unless permitted_params[:reverse_transaction_id].present?
    OpenbillTransaction.find permitted_params[:reverse_transaction_id]
  end

  def transaction
    OpenbillTransaction.find params[:id]
  end

  def ransack
    OpenbillTransaction.ransack params[:q]
  end

  def transactions
    ransack.result.order('created_at asc')
  end

  def pending_webhooks_transactions
    # TODO
    raise 'todo'
    filter.apply(OpenbillTransaction.get_pending_webhooks_transactions)
  end

  def permitted_params
    return {} unless params[:transaction].present?
    # Allow any parameters
    params.require(:transaction).permit!
  end
end
