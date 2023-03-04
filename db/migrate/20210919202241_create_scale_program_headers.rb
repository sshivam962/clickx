class CreateScaleProgramHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :scale_program_headers do |t|
      t.string :name
      t.integer :week
      
      t.timestamps
    end
  end
end
