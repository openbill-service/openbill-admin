class GoodsController < ApplicationController
  def index
    render locals: { goods: goods.eager(:group).all }
  end

  def new
    good_form = GoodForm.new
    render locals: { good_form: good_form }
  end

  def edit
    good_form = GoodForm.new good
    render locals: { good_form: good_form }
  end

  def update
    good_form = GoodForm.new({ **permitted_params.symbolize_keys, id: good.id })

    if good_form.valid?
      good.update good_form.to_hash
      redirect_to goods_path
    else
      render :edit, locals: { good_form: good_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { good_form: good_form }
  end

  def create
    good_form = GoodForm.new permitted_params

    if good_form.valid?
      goods.insert good_form.to_hash
      redirect_to goods_path
    else
      render :new, locals: { good_form: good_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { good_form: good_form }
  end

  def destroy
    good.delete
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def goods
    Openbill.service.goods
  end

  def good
    goods.first! id: params[:id]
  end

  def permitted_params
    params.require(:good).permit(:group_id, :title, :unit, :details, :meta)
  end
end
