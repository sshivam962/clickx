class RemoveSessionsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :sessions
  end
end
