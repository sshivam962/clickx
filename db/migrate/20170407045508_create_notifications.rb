class CreateNotifications < ActiveRecord::Migration[4.2]
  def change
    create_table :notifications do |t|
      t.text :content
      t.string :action, null: false
      t.references :user, index: true, foreign_key: true
      t.references :actor, polymorphic: true, index: true
      # t.references :action, polymorphic: true, index: true
      t.references :target, polymorphic: true, index: true
      t.datetime :read_at

      t.timestamps null: false
    end
  end
end
