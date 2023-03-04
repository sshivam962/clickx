class CreateWatchHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :watch_histories do |t|
      t.datetime :first_seen
      t.datetime :last_seen

      t.references :course, index: true
      t.references :chapter, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
