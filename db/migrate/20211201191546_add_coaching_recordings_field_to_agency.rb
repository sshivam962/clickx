class AddCoachingRecordingsFieldToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :coaching_recordings, :boolean, default: false
  end
end
