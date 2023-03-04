class CreateSupportMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :support_members do |t|
      t.string          :name
      t.string          :image
      t.references      :agency
      t.timestamps
    end
  end
end
