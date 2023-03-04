class Agency::TodoItemsController < Agency::BaseController
  before_action :set_list, only: %i[show new create edit update destroy update_status update_position]
  before_action :set_item, only: %i[show edit update destroy update_status update_position]

  def create
    @list.todo_items.create(item_params)
  end

  def update
    @item.update(item_params)
  end

  def destroy
    @item.destroy
  end

  def update_status
    if ActiveModel::Type::Boolean.new.cast(params[:checked])
      @item.complete!
    else
      @item.uncomplete!
    end
  end

  def update_position
    @item.insert_at(params[:position].to_i)
  end

  private

  def set_list
    @list = current_agency.todo_lists.find(params[:todo_list_id])
  end

  def set_item
    @item = @list.todo_items.find(params[:id])
  end

  def item_params
    params.require(:todo_item).permit(:content, :description)
  end
end
