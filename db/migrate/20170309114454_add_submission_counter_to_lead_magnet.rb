class AddSubmissionCounterToLeadMagnet < ActiveRecord::Migration[4.2]
  def change
    change_table :tracker_lead_magnets do |t|
      t.integer :submissions_count, default: 0
    end

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE tracker_lead_magnets
           SET submissions_count = (SELECT count(1)
                                   FROM tracker_lead_magnet_submissions
                                  WHERE tracker_lead_magnet_submissions.tracker_lead_magnet_id = tracker_lead_magnets.id)
    SQL
  end
end
