class RemoveAcceptedColumnFromProjectProposal < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_proposals, :accepted
  end
end
