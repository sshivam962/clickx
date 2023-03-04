class AddAcceptedColumnToProjectProposal < ActiveRecord::Migration[5.1]
  def change
    add_column :project_proposals, :accepted, :boolean, default: false
  end
end
