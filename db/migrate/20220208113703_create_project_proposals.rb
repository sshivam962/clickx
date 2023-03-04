class CreateProjectProposals < ActiveRecord::Migration[5.1]
  def change
    create_table :project_proposals do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
