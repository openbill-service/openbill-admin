class PoliciesController < ApplicationController
  def index
    render locals: { policies: policies.includes(:from_account,
                                              :to_account,
                                              :from_category,
                                              :to_category).all }
  end

  def new
    render locals: { policy: OpenbillPolicy.new }
  end

  def edit
    render :edit, locals: { policy: policy }
  end

  def create
    policy = OpenbillPolicy.new permitted_params

    if policy.save
      redirect_to policies_path
    else
      render :new, locals: { policy: policy_form }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { policy: policy_form }
  end

  def update
    policy.update permitted_params

    if policy.valid?
      redirect_to policies_path
    else
      render :edit, locals: { policy: policy }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { policy: policy }
  end

  def destroy
    policy.destroy!
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def policy
    OpenbillPolicy.find params[:id]
  end

  def permitted_params
    params.require(:policy).permit(:name, :from_category_id, :to_category_id,
                                   :from_account_id, :to_account_id)
  end

  def policies
    @_policies ||= OpenbillPolicy.all
  end
end
