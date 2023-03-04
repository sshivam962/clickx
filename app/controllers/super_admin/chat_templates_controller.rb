class SuperAdmin::ChatTemplatesController < ApplicationController
  before_action :current_chat_template, only: [:update, :destroy]
  layout 'base'

  def index
    @chat_templates = ChatTemplate.order('id DESC').all
  end

  def create
    @chat_template = ChatTemplate.new(chat_template_params)
    if @chat_template.save
      flash[:notice] = 'Successfully saved'
    else
      flash[:error] = @chat_template.errors.full_messages
    end
    redirect_to super_admin_chat_templates_path
  end

  def update
    @chat_template = ChatTemplate.find(params[:id]).update(chat_template_params)
    flash[:notice] = "Successfully Updated"
    redirect_to super_admin_chat_templates_path
  end

  def destroy
    @cht_tmp = ChatTemplate.find(params[:id])
    @cht_tmp.destroy
    flash[:notice] = "Successfully deleted"
    redirect_to super_admin_chat_templates_path
  end

  private

  def chat_template_params
    params.require(:chat_template).permit(:template_name, :template_data)
  end

  def current_chat_template
    @chat_template = ChatTemplate.find(params[:id])
  end
end
