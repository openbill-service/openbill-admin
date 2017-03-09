class InvoicesController < ApplicationController
  def index
    render locals: { invoices: invoices }
  end

  def new
    render locals: { invoice: InvoiceForm.new }
  end

  def show
    respond_to do |format|
      format.html do
        render locals: { invoice: invoice }
      end
      format.pdf do
        render pdf: 'show.pdf', locals: { invoice: invoice }, layout: false
      end
    end
  end

  def edit
    invoice_form = InvoiceForm.new invoice
    render :edit, locals: { invoice: invoice_form }
  end

  def create
    invoice_form = InvoiceForm.new permitted_params

    if invoice_form.valid?
      invoices.insert invoice_form.to_hash
      redirect_to invoices_path
    else
      render :new, locals: { invoice: invoice_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { invoice: invoice_form }
  end

  def update
    invoice_form = InvoiceForm.new({ **permitted_params.symbolize_keys, id: invoice.id })

    if invoice_form.valid?
      invoice.update invoice_form.to_hash
      redirect_to invoices_path
    else
      render :edit, locals: { invoice: invoice_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { invoice: invoice_form }
  end

  def destroy
    invoice.delete
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def invoice
    OpenbillInvoice.find params[:id]
  end

  def permitted_params
    params.require(:invoice).permit(:date, :number, :title, :destination_account_id, :amount_cents, :amount_currency)
  end

  def invoices
    @_invoices ||= OpenbillInvoice.all
  end
end
