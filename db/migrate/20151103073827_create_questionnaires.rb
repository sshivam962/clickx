class CreateQuestionnaires < ActiveRecord::Migration[4.2]
  def change
    create_table :questionnaires do |t|

      t.timestamps null: false
    end
  end
end
