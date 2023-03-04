class Agency::TodoListsController < Agency::BaseController
  before_action :set_todo_list, only: [:edit, :update, :destroy]

  def index
    @lists = current_agency.todo_lists
  end

  def create
    current_agency.todo_lists.create(list_params)
    redirect_to agency_support_path
  end

  def update
    @list.update(list_params)
  end

  def destroy
    @list.destroy
  end

  private

  def set_todo_list
    @list = current_agency.todo_lists.find(params[:id])
  end

  def list_params
    params.require(:todo_list).permit(:title)
  end
end
