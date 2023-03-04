class ChangeUnbounceIdsTypeInBusinesses < ActiveRecord::Migration[4.2]
  def up
    remove_column :businesses , :unbounce_ids 
    add_column :businesses,:unbounce_ids,:jsonb, default: {}
  end

  def down
    remove_column :businesses , :unbounce_ids
    add_column :businesses,:unbounce_ids,:integer, {array: true, default: []}
  end
end
