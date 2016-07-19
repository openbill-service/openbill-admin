class TransactionsController < ApplicationController
  helper_method :filter

  def index
    render locals: {
      transactions: transactions.eager(*transaction_eager).paginate(page, per_page),
      transactions_count: transactions.count
    }
  end

  def new
    if reverse_transaction.present?
      transaction_form.amount_cents = reverse_transaction.amount.to_f
      transaction_form.amount_currency = reverse_transaction.amount_currency
      transaction_form.from_account_id = reverse_transaction.to_account_id
      transaction_form.to_account_id = reverse_transaction.from_account_id
      transaction_form.key = reverse_transaction.key + '-reverse'
      transaction_form.date = reverse_transaction.date
      transaction_form.details = "Reverse of #{reverse_transaction.details}"
    end
    render locals: { transaction: transaction_form }
  end

  def edit
    transaction_form = TransactionForm.new transaction
    render :new, locals: { transaction: transaction_form }
  end

  def create
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

  def update
    transaction_form = TransactionForm.new({ **permitted_params.symbolize_keys, id: transaction.id, date: date })
    if transaction_form.valid?
      transaction.update transaction_form.to_hash
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

  def show
    render locals: { transaction: transaction }
  end

  def destroy
    transaction.delete
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def transaction_form
    TransactionForm.new({
      **permitted_params.symbolize_keys,
      date: date
    })
  end

  def date
    return unless params.key?(:transaction)
    TransactionDate.parse permitted_params
  end

  def transaction_eager
    if Features.has_goods?
      [:good, :from_account, :to_account]
    else
      [:from_account, :to_account]
    end
  end

  def reverse_transaction
    return nil unless permitted_params[:reverse_transaction_id].present?
    Openbill.service.get_transaction permitted_params[:reverse_transaction_id]
  end

  def transaction
    Openbill.service.get_transaction params[:id]
  end

  def transactions
    filter.apply(Openbill.service.transactions.reverse_order(:created_at))
  end

  def permitted_params
    return {} unless params[:transaction].present?
    # Allow any parameters
    params.require(:transaction).permit!
  end
end
