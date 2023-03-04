# Migration responsible for creating a table with activities
class CreateActivityEvents < ActiveRecord::Migration[4.2]
  # Create table
  def self.up
    create_table :activity_events do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.string  :key
      t.text    :parameters
      t.belongs_to :recipient, :polymorphic => true

      t.timestamps
    end

    add_index :activity_events, [:trackable_id, :trackable_type]
    add_index :activity_events, [:owner_id, :owner_type]
    add_index :activity_events, [:recipient_id, :recipient_type]
  end
  # Drop table
  def self.down
    drop_table :activity_events
  end
end
