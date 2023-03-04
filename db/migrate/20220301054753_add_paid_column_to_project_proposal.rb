class AddPaidColumnToProjectProposal < ActiveRecord::Migration[5.1]
  def change
    add_column :project_proposals, :paid, :boolean, default: false
  end
end
