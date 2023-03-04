class SuperAdmin::AdminManageFaqsController < SuperAdmin::BaseController
  layout 'base'
  before_action :set_admin_faq, only: %i[edit update destroy sort]
  before_action :perform_authorization

  def index
    @admin_faqs = AdminFaq.order(position: :asc)
  end

  def new
    @admin_faq = AdminFaq.new
  end

  def create
    @admin_faq = AdminFaq.new(faq_params)
    if @admin_faq.save
      flash[:success] = 'Faq created'
      redirect_to super_admin_admin_manage_faqs_path
    else
      flash[:error] = @admin_faq.errors.full_messages.to_sentence
      redirect_to new_super_admin_admin_manage_faq_path(@admin_faq)
    end
  end

  def edit;end

  def update
    if @admin_faq.update(faq_params)
      flash[:success] = 'Faq updated'
      redirect_to super_admin_admin_manage_faqs_path
    else
      flash[:error] = @admin_faq.errors.full_messages.to_sentence
      redirect_to edit_super_admin_admin_manage_faq_path(@admin_faq)
    end
  end

  def destroy
    @admin_faq.destroy
    flash[:success] = 'Faq deleted'
    redirect_to super_admin_admin_manage_faqs_path
  end

  def sort
    @admin_faq.insert_at(params[:position].to_i)
  end

  private

  def faq_params
    params.require(:admin_faq).permit(:question, :answer)
  end

  def set_admin_faq
    @admin_faq = AdminFaq.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin admin_manage_faq]
  end

end
