class SuperAdmin::FaqsController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_faq, only: %i[edit update destroy sort]

  def index
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      flash[:success] = 'Faq updated Successfully'
      redirect_to super_admin_faqs_path
    else
      flash[:error] = @faq.errors.full_messages.to_sentence
      redirect_to new_super_admin_faq_path(@faq)
    end
  end

  def edit; end

  def update
    if @faq.update(faq_params)
      flash[:success] = 'faq updated Successfully'
      redirect_to super_admin_faqs_path
    else
      flash[:error] = @faq.errors.full_messages.to_sentence
      redirect_to edit_super_admin_faq_path(@faq)
    end
  end

  def destroy
    @faq.destroy
    redirect_to super_admin_faqs_path
  end

  def sort
    @faq.insert_at(params[:position].to_i)
  end

  private

  def faq_params
    params.require(:faq)
          .permit(:question, :answer, :section)
  end

  def set_faq
    @faq = Faq.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin faq]
  end
end
