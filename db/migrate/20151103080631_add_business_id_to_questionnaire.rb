class AddBusinessIdToQuestionnaire < ActiveRecord::Migration[4.2]
  def change
    add_column :questionnaires, :business_id, :integer
  end
end
