class SuperAdmin::PaymentLinksController < SuperAdmin::BaseController
  before_action :set_payment_link, only: %i[edit update destroy disabled]

  def index
    @payment_links = if current_user.clickx_admin?
      AdminPaymentLink.includes(:admin_plan).order(created_at: :desc)
    else
      current_user.admin_payment_links.includes(:admin_plan).order(created_at: :desc)
    end
  end

  def new
    @payment_link = AdminPaymentLink.new
    @payment_link.build_admin_plan
  end

  def create
    @payment_link = current_user.admin_payment_links.new(payment_link_params)

    if @payment_link.save
      flash[:success] = 'Payment Link Created'
      redirect_to super_admin_payment_links_path
    else
      flash[:notice] = @payment_link.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def disabled
    @payment_link.toggle!(:disabled)
  end

  def destroy
    @payment_link.destroy
  end

  def edit; end

  def update
    if @payment_link.update(payment_link_update_params)
      flash[:success] = 'Payment Link Created'
      redirect_to super_admin_payment_links_path
    else
      flash[:notice] = @payment_link.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def clone
    og_link = AdminPaymentLink.find(params[:id])
    @payment_link = og_link.dup
    @payment_link.build_admin_plan(og_link.admin_plan.dup.attributes)

    render 'new'
  end

  private

  def set_payment_link
    @payment_link = AdminPaymentLink.find(params[:id])
  end

  def payment_link_params
    params.require(:admin_payment_link).permit(
      :email, :name,
      admin_plan_attributes: [
        :id, :description_line_1, :description_line_2, :amount,
        :billing_category, :implementation_fee, :pay_with_implementation_fee
      ]
    )
  end

  def payment_link_update_params
    params.require(:admin_payment_link).permit(
      :email, :name,
      admin_plan_attributes: [:id, :description_line_1, :description_line_2]
    )
  end
end
