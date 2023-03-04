class AddAcceptedProposalIdToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :accepted_proposal_id, :integer
    add_index :projects, :accepted_proposal_id
  end
end
