class PoliciesController < ApplicationController
  def index
    render locals: { policies: policies.eager(:from_account,
                                              :to_account,
                                              :from_category,
                                              :to_category).all }
  end

  def new
    render locals: { policy: PolicyForm.new }
  end

  def edit
    policy_form = PolicyForm.new policy
    render :edit, locals: { policy: policy_form }
  end

  def create
    policy_form = PolicyForm.new permitted_params
    policies.insert policy_form.to_hash
    redirect_to policies_path
  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { policy: policy_form }
  end

  def update
    policy_form = PolicyForm.new({ **permitted_params.symbolize_keys, id: policy.id })

    if policy_form.valid?
      policy.update policy_form.to_hash
      redirect_to policies_path
    else
      render :edit, locals: { policy: policy_form }
    end
  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { policy: policy_form }
  end

  def destroy
    policy.delete
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def policy
    policies.first! id: params[:id]
  end

  def permitted_params
    params.require(:policy).permit(:name, :from_category_id, :to_category_id,
                                   :from_account_id, :to_account_id)
  end

  def policies
    @_policies ||= Openbill.service.policies
  end
end
